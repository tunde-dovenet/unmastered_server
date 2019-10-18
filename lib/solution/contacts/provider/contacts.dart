import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unmastered_server/models/http_exception.dart';
import 'package:unmastered_server/solution/contacts/provider/contact.dart';

class Contacts with ChangeNotifier {
  List<Contact> _items = [];

  final String authToken;
  final String userId;

  Contacts(this.authToken, this.userId, this._items);

  List<Contact> get items {
    return [..._items];
  }

  void removeContact(String listId) {
    _items.remove(listId);
    notifyListeners();
  }

  Contact findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> filterLocation(state) async {
    final location = 'orderBy="state"&equalTo="$state"';
    var url = 'https://unmasteredserver.firebaseio.com/contacts.json?auth=$authToken&$location';
    
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://unmasteredserver.firebaseio.com/contacts.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Contact> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Contact(
          id: prodId,
          fName: prodData['firstName'],
          lName: prodData['lastName'],
          phone: prodData['phoneNumber'],
          state: prodData['state'],
          lGA: prodData['lGA'],
          email: prodData['eMail'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addContact(Contact contact) async {
    final url = 'https://unmasteredserver.firebaseio.com/contacts.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'firstName': contact.fName,
          'lastName': contact.lName,
          'phoneNumber': contact.phone,
          'state': contact.state,
          'lGA': contact.lGA,
          'eMail': contact.email,
          'creatorId' : userId,
        }),
      );
      final newContact = Contact(
        fName: contact.fName,
        lName: contact.lName,
        phone: contact.phone,
        state: contact.state,
        lGA: contact.lGA,
        email: contact.email,
        id: json.decode(response.body)['name'],
      );
      _items.add(newContact);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateContact(String id, Contact newContact) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://unmasteredserver.firebaseio.com/contacts/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'firstName': newContact.fName,
            'lastName': newContact.lName,
            'phoneNumber': newContact.phone,
            'state': newContact.state,
            'lGA': newContact.lGA,
            'eMail': newContact.email
          }));
      _items[prodIndex] = newContact;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteContacts(String id) async{
    final url =
        'https://unmasteredserver.firebaseio.com/contacts/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
