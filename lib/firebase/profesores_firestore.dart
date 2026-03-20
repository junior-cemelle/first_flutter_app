import 'package:cloud_firestore/cloud_firestore.dart';

class ProfesoresFirestore {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference ? procesoresCollection;

  ProfesoresFirestore() {
    procesoresCollection = _firestore.collection("profesores");
  }

  insertProfesor(Map<String, dynamic> data) {
    return procesoresCollection!.doc().set(data);
  }

  updateProfesor(Map<String, dynamic> data, String id) {
    return procesoresCollection!.doc(id).update(data);
  }

  deleteProfesor(String id) {
    return procesoresCollection!.doc(id).delete();
  }

  Stream<QuerySnapshot> getProfesores() {
    return procesoresCollection!.snapshots();
  }
}