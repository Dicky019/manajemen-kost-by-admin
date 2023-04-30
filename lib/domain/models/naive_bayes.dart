// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:manajemen_kost_by_admin/domain/core/core.dart';

class NaiveBayesModel {
  final String? id;
  final Timestamp? tglJatuhTempo;
  final DocumentReference? idKamar;
  final bool? statusKamar;
  final List<String>? riwayatPembayaran;

  NaiveBayesModel({
    this.id,
    required this.tglJatuhTempo,
    required this.idKamar,
    this.statusKamar,
    this.riwayatPembayaran,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tglJatuhTempo': tglJatuhTempo,
      'idKamar': idKamar,
      'statusKamar': statusKamar,
      'riwayatPembayaran': riwayatPembayaran,
    };
  }

  factory NaiveBayesModel.fromMap(Map<String, dynamic> map) {
    final dataKamar = map['idKamar'] as DocumentReference;
    DocumentReference<KamarModel> idKamar = dataKamar.withConverter(
      fromFirestore: (snapshot, options) =>
          KamarModel.fromDocumentSnapshot(snapshot),
      toFirestore: (value, options) => value.toMap(),
    );
    return NaiveBayesModel(
      id: map['id'] != null ? map['id'] as String : null,
      tglJatuhTempo: map['tglJatuhTempo'] != null
          ? map['tglJatuhTempo'] as Timestamp
          : null,
      idKamar: idKamar,
      statusKamar:
          map['statusKamar'] != null ? map['statusKamar'] as bool : null,
      // riwayatPembayaran: map['riwayatPembayaran'] ?? [],
    );
  }
  factory NaiveBayesModel.fromMapByID(Map<String, dynamic> map, String id) {
    final dataKamar = map['idKamar'] as DocumentReference;
    DocumentReference<KamarModel> idKamar = dataKamar.withConverter(
      fromFirestore: (snapshot, options) =>
          KamarModel.fromDocumentSnapshot(snapshot),
      toFirestore: (value, options) => value.toMap(),
    );
    return NaiveBayesModel(
      id: id,
      tglJatuhTempo: map['tglJatuhTempo'] != null
          ? map['tglJatuhTempo'] as Timestamp
          : null,
      idKamar: idKamar,
      statusKamar:
          map['statusKamar'] != null ? map['statusKamar'] as bool : null,
      // riwayatPembayaran: map['riwayatPembayaran'] ?? [],
    );
  }

  factory NaiveBayesModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return NaiveBayesModel.fromMapByID(data, snapshot.id);
  }
}
