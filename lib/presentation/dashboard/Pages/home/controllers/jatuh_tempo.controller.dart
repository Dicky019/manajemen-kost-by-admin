import 'dart:developer';

import '../../../../../domain/core/core.dart';

class JatuhTempoController extends GetxController
    with StateMixin<List<JatuhTempoModel>> {
  final tglSkrg = Timestamp.now().toDate();

  List<JatuhTempoModel> listJatuhTempo = [];
  List<JatuhTempoModel>? listWhere = [];

  void onChange(String value, RxBool isSearch) {
    value.isEmpty ? isSearch.value = false : isSearch.value = true;

    change(
      value.isEmpty
          ? listWhere
          : listWhere!
              .where((element) => element.idKamar!.id.toLowerCase().contains(
                    value.toLowerCase(),
                  ))
              .toList(),
      status: RxStatus.success(),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get penghuniStream =>
      ConstansApp.firebaseFirestore
          .collection(ConstansApp.naiveBayesCollection)
          .snapshots();

  @override
  void onInit() {
    penghuniStream.listen((event) {
      if (event.size == 0) {
        log("empty");
        change(null, status: RxStatus.empty());
      } else {
        listJatuhTempo = List.generate(event.docs.length, (index) {
          final data = event.docs[index];
          log("data jatuh tempo ${data.data()}");
          return JatuhTempoModel.fromDocumentSnapshot(data);
        });
        log("naive bayes ${listJatuhTempo.length}");
        listWhere = listJatuhTempo
            .where(
              (e) =>
                  e.terisi == true &&
                  e.statusKamar == false &&
                  tglSkrg.difference(e.tglJatuhTempo!.toDate()).inDays >= 0,
            )
            .toList();
        log("listWhere ${listWhere!.length}");
        change(listWhere, status: RxStatus.success());
      }
    });
    listJatuhTempo.sort((a, b) => a.tglJatuhTempo!.compareTo(b.tglJatuhTempo!));
    super.onInit();
  }
}
