import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/no_data_found.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';
import '../volunteer_screens/navigation_pickup.dart';
import '../volunteer_screens/volunteer_delivery_details.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> acceptedData = [];

  final _prefs = AppConfig().preferences;

  var loading = true;

  @override
  void initState() {
    super.initState();
    getAcceptedList();
  }

  getAcceptedList() async {
    setState(() {
      loading = true;
    });

    // getProfileDetails =
    //     UserProfileService(repository: repository).getUserProfileService();

    try {

      print("userId : ${_prefs?.getString(AppConfig.userId)}");

      final response = await supabase
          .from('ashram_requests')
          .select('*')
          .eq('volunteer_id', "${_prefs?.getString(AppConfig.userId)}");

      acceptedData = response;

      print("accepted orders : $acceptedData");
    } on PostgrestException catch (error) {
      AppConfig().showSnackbar(context, error.message, isError: true);
    } catch (error) {
      AppConfig()
          .showSnackbar(context, 'Unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h,left: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildAppBar(
                      () {},
                  isBackEnable: false,
                  showLogo: false,
                  showChild: true,
                  child: Text(
                    "Accepted Orders",
                    style: TextStyle(
                      fontFamily: kFontBold,
                      fontSize: 15.dp,
                      color: gBlackColor,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: loading
                        ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 35.h),
                      child:
                      buildThreeBounceIndicator(color: gBlackColor),
                    )
                        : acceptedData.isEmpty
                        ? const NoDataFound()
                        : buildProfileDetails(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildProfileDetails(){
    return ListView.builder(
      itemCount: acceptedData.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        dynamic file = acceptedData[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NavigationPickUp(
                            ashramId: file['ashram_id'].toString(),
                  donorId: file['donor_id'].toString(),
                          ),
              ),
            );

          },
          child: Container(
            height: 14.h,
            margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: gGreyColor,
                width: 1.5,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.h,
                    width: 32.w,
                    decoration: BoxDecoration(
                      color: imageBackGround,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ImageNetwork(
                      image: '',
                      height: 14.h,
                      width: 32.w,
                      // duration: 1500,
                      curve: Curves.easeIn,
                      onPointer: true,
                      debugPrint: false,
                      fullScreen: false,
                      fitAndroidIos: BoxFit.cover,
                      fitWeb: BoxFitWeb.contain,
                      borderRadius: BorderRadius.circular(12),
                      onError: const Icon(
                        Icons.image_outlined,
                        color: loginButtonSelectedColor,
                      ),
                      onTap: () {
                        debugPrint("©gabriel_patrick_souza");
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file['food_items'],
                              style: TextStyle(
                                fontSize: listHeadingSize,
                                fontFamily: listHeadingFont,
                                color: gBlackColor,
                              ),
                            ),
                            Text(
                              "${file['food_quantity']}",
                              style: TextStyle(
                                fontSize: listSubHeadingSize,
                                height: 1.3,
                                fontFamily: listSubHeadingFont,
                                color: gBlackColor,
                              ),
                            ),
                            SizedBox(height: 1.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file['cooking_date'],
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer_sharp,
                                      size: 1.5.h,
                                      color: gBlackColor,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file['cooking_time'],
                                      style: TextStyle(
                                        fontSize: listOtherSize,
                                        fontFamily: listOtherFont,
                                        color: gBlackColor,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5.h),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Pickup Time : ",
                                    style: TextStyle(
                                      fontSize: 11.dp,
                                      height: 1.5,
                                      fontFamily: kFontBook,
                                      color: gBlackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: file['pickup_time'],
                                    style: TextStyle(
                                      fontSize: 11.dp,
                                      height: 1.5,
                                      fontFamily: kFontBold,
                                      color: gBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class Data {
  final String name;
  final String address;
  final int isFrom;

  const Data({
    required this.name,
    required this.address,
    required this.isFrom,
  });
}

const List<Data> dummyData = [
  Data(
    name: "The Big Brunch",
    address: "Drop of Arun school",
    isFrom: 1,
  ),
  Data(
    name: "Blind School",
    address: "Avenue Colony, Flat No.404",
    isFrom: 0,
  ),
];
