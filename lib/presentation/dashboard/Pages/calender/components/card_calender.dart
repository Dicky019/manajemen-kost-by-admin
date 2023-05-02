import '../../../../../domain/core/core.dart';

class CardCalender extends GetView<CalenderController> {
  final void Function()? onTap;
  final NaiveBayesModel? data;
  const CardCalender({
    Key? key,
    required this.onTap,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sisa3Hari = data is TerdekatModel;
    final day = data!.tglJatuhTempo!.toDate().day;
    final month = data!.tglJatuhTempo!.toDate().month;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: sisa3Hari
                ? [
                    Colors.yellow.shade600,
                    Colors.yellow.shade800,
                    Colors.yellow.shade900,
                    // const Color(0xffff1744),
                  ]
                : [
                    Colors.red.shade300,
                    Colors.red.shade500,
                    Colors.red.shade800,
                    // const Color(0xffff1744),
                  ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sisa3Hari ? '3 hari ke depan' : 'Hari ini',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorApp.white,
                      fontSize: 13,
                    ),
                  ),
                  if (sisa3Hari)
                    Text(
                      '$day ${controller.monthsFormat[month - 1]} ',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorApp.red,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              SizeApp.h6,
              Row(
                children: [
                  StreamBuilder<DocumentSnapshot<KamarModel>>(
                    stream: controller.methodApp
                        .kamar(data!.idKamar!.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final kamarModel = snapshot.data!.data()!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sisa3Hari
                                ? RichText(
                                    text: TextSpan(
                                      text: 'Kamar dengan ',
                                      style: const TextStyle(
                                        color: ColorApp.white,
                                        fontSize: 14,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              'No. ${kamarModel.id}, ${kamarModel.lantai}, ${kamarModel.gedung},',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorApp.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const TextSpan(
                                          text:
                                              ' dalam \n3 hari ke depan akan jatuh tempo',
                                          style: TextStyle(
                                            color: ColorApp.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      text: 'Kamar dengan ',
                                      style: const TextStyle(
                                        color: ColorApp.white,
                                        fontSize: 14,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              'No. ${kamarModel.id}, ${kamarModel.lantai}, ${kamarModel.gedung},',
                                          style: const TextStyle(
                                            color: ColorApp.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                          text:
                                              ' telah \nmencapai tanggal pembayaran',
                                          style: TextStyle(
                                            color: ColorApp.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            SizeApp.h12,
                            StreamBuilder<DocumentSnapshot<PenghuniModel>>(
                              stream: controller.methodApp
                                  .penghuni(kamarModel.penghuni!.first.id)
                                  .snapshots(),
                              builder: (ctx, s) {
                                if (s.hasData) {
                                  final penghuniModel = s.data!.data()!;
                                  return Text(
                                    '${penghuniModel.nama} - ${penghuniModel.peran}',
                                    style: const TextStyle(
                                      color: ColorApp.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  );
                                }
                                return const Text(
                                  'Proses ...',
                                  style: TextStyle(
                                    color: ColorApp.white,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      }
                      return const LoadingState();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
