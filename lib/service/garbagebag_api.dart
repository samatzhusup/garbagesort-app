import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbagesort/model/Garbage.dart';

class GarbageBagService {
  static final GarbageBagService _categoryService = GarbageBagService._internal();
  Firestore _db = Firestore.instance;

  GarbageBagService._internal();

  factory GarbageBagService() {
    return _categoryService;
  }

  Future<void> createBag(String bagId,status) async {
    Firestore.instance.collection("garbagebag").document(bagId).updateData(status).catchError((e) {
      print(e);
    });
  }

  Future<void> updateStatus(String bagId,status) async {
    Firestore.instance.collection("clinetbag").document(bagId).updateData(status).catchError((e) {
      print(e);
    });
  }

  Stream<List<Garbage>> getClientHomeGarbageBag(String uId) {
    return _db.collection('clinetbag').where("uid",isEqualTo: uId).where("status",isEqualTo: "home").orderBy("created",descending: true).snapshots().map(
            (snapshot) => snapshot.documents.map(
               (doc) => Garbage.fromMap(doc.data, doc.documentID),
        ).toList()
    );
  }

  Stream<List<Garbage>> getClientGarbageBaginCon(String uId) {
    return _db.collection('clinetbag').where("uid",isEqualTo: uId).where("status",isEqualTo: "container").snapshots().map(
            (snapshot) => snapshot.documents.map(
              (doc) => Garbage.fromMap(doc.data, doc.documentID),
        ).toList()
    );
  }

  Stream<List<Garbage>> getGarbageBag(String bagId) {
    return _db.collection('garbagebag').where("bagId",isEqualTo: bagId).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Garbage.fromMap(doc.data, doc.documentID),
      ).toList()
    );
  }

  Future<void> createPlasticBag(data) async {
    Firestore.instance.collection("clinetbag").add(data).catchError((e) {
      print(e);
    });
  }

  Stream<DocumentSnapshot> getGarbageList (String bagId) {
    return _db.collection('clinetbag').document(bagId).snapshots();
  }

}
