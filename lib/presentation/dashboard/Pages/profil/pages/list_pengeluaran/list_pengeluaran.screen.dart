import 'package:grouped_list/grouped_list.dart';

import '../../../../../../domain/core/core.dart';

class ListPengeluaranScreen extends GetView<ListPengeluaranController> {
  const ListPengeluaranScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: appBarBatal('Pemasukan', Get.back),
      body: controller.obx(
        (state) => GroupedListView<PengeluaranModel, String>(
          elements: state!,
          groupBy: (e) => controller.groupBy(e),
          groupComparator: (value1, value2) => value2.compareTo(value1),
          itemComparator: (item1, item2) => item1.idr.compareTo(item2.idr),
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) => GroupSeparator(
            value,
            onTap: () {},
          ),
          itemBuilder: (c, e) => ValueGrub(
            e,
            onTap: () {
              Get.to(DetailPengeluaran(e: e));
            },
          ),
        ),
        onEmpty: const Center(child: Text("Masih Kosong")),
        onLoading: const LoadingState(),
        onError: (e) {
          return Center(child: Text("error : $e"));
        },
      ),
    );
  }
}
