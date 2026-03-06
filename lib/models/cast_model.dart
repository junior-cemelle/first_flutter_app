//import 'package:flutter/foundation.dart';

class CastDAO {
  int? idCast;
  String? nameCast;
  String? bitrhCast;
  String? genderCast;

  CastDAO({this.idCast, this.nameCast, this.bitrhCast, this.genderCast});

  factory CastDAO.fromMap(Map<String, dynamic> cast) {
    return CastDAO(
      idCast: cast['idCast'],
      nameCast: cast['nameCast'],
      bitrhCast: cast['bitrhCast'],
      genderCast: cast['genderCast']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCast': idCast,
      'nameCast': nameCast,
      'bitrhCast': bitrhCast,
      'genderCast': genderCast
    };
  }
}