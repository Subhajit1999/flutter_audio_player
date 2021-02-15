import 'dart:async';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/menu_config.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_bloc.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_event.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_state.dart';
import 'package:flutter_audio_player/screens/main/ui/widgets/storage_tab_view.dart';
import 'package:flutter_audio_player/services/ad_manager.dart';
import 'package:flutter_audio_player/services/network_manager.dart';
import 'package:flutter_audio_player/services/permissions_service.dart';
import 'package:flutter_audio_player/shared/toolbar.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/static.dart';
import 'package:flutter_audio_player/utils/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  FileScannerBloc scannerBloc;
  static AdmobBanner bannerAd;
  bool networkConnected = false;

  @override
  void initState() {
    super.initState();
    scannerBloc = BlocProvider.of<FileScannerBloc>(context);
    _tabController = TabController(length: 2, vsync: this);
    requestPermission();
  }

  _handleAdInit() {
    if(bannerAd == null) {
      NetworkManager.isNetworkConnected().then((value) {
        networkConnected = value;
        if(value) {
          bannerAd = AdMobManager.buildBannerAd(Statics.bannerSize);
          setState(() {});
        }
      });
    }
  }

  _disconnectAudioService() async {
    // Disconnecting the AudioService
    await AudioService.disconnect();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    bannerAd = null;
    _disconnectAudioService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: ToolBar(Strings.appName, true, action: popupMenu(),),
      body:  mainBody()
    );
  }

  Widget mainBody() {
    return Container(
        width: double.infinity,
        height: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(2.5 * SizeConfig.heightMultiplier),
                topEnd: Radius.circular(2.5 * SizeConfig.heightMultiplier))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.6 * SizeConfig.widthMultiplier),
              child: Text('Local Albums', style: Theme.of(context).textTheme.headline4),
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),

            // If external available then show TabBar, else only internal List
            // BlocBuilder is just to refresh this portion of the UI.
            BlocBuilder<FileScannerBloc, FileScannerState>(
              bloc: scannerBloc,
              builder: (BuildContext context, FileScannerState state) {
                if (state is FileScanSuccessState) {
                  _handleAdInit();
                  return Expanded(
                    child: Column(
                      children: [
                        Statics.availableStorage.length>1? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.6 * SizeConfig.widthMultiplier),
                          child: storageTabBar(),
                        ) : Expanded(child: StorageTabView(0)),
                        Statics.availableStorage.length>1? SizedBox(height: 3 * SizeConfig.heightMultiplier,) : SizedBox(),
                        Statics.availableStorage.length>1? tabViewChildren() : SizedBox(),
                      ],
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            Align(
              alignment: Alignment.bottomCenter,
              child: networkConnected && bannerAd!=null? Container(
                width: double.infinity,
                height: Statics.adContainerHeight,
                color: AppColors.accentColor,
                child: Center(child: bannerAd),
              ) : SizedBox(),
            )
          ],
        )
    );
  }

  Widget popupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(FontAwesomeIcons.ellipsisH, size: 5 * SizeConfig.widthMultiplier,),
      onSelected: handleClick,
      itemBuilder: (BuildContext context) {
        return AppbarMenuConfig.appbarMenuItems .map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void handleClick(String value) {
    switch (value) {
    }
  }

  Widget storageTabBar() {
    return Container(
      height: 5.625 * SizeConfig.heightMultiplier,
      padding: EdgeInsets.all(0.5 * SizeConfig.heightMultiplier),
      decoration: BoxDecoration(
        color: AppColors.inactiveTabIndicatorColor,
        borderRadius: BorderRadius.circular(
          3.125 * SizeConfig.textMultiplier,
        ),
      ),

      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            3.125 * SizeConfig.textMultiplier,
          ),
          color: AppColors.activeTabIndicatorColor.withOpacity(0.85),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.secondaryColor,
        labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 2 * SizeConfig.textMultiplier
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 2 * SizeConfig.textMultiplier
        ),
        tabs: [
          Tab(text: 'Phone',),
          Tab(text: 'SD Card',),
        ],
      ),
    );
  }

  Widget tabViewChildren() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          //Internal Storage
          StorageTabView(0),

          //External Storage
          StorageTabView(1),
        ],
      ),
    );
  }

  void requestPermission() {
    PermissionsService().hasStoragePermission().then((value) {   // If permission doesn't exist
      if(!value) {
        PermissionsService().requestStoragePermission(
            onPermissionDenied: () => _showPermissionDialog(requestPermission)
        ).then((value) {
          if(value) {   // If permission granted, do operation
            fetchFilesFromStorage();
          }
        });
      } else {   // If permission granted already
        fetchFilesFromStorage();
      }
    });
  }

  Future<void> fetchFilesFromStorage() async {
    //Triggering File Scanner Bloc
    scannerBloc.add(ScanFileStorage());
  }
  
  void _showPermissionDialog(Function rqstPermission) {
    Alert(
        context: context,
        title: "Storage Permission Denied",
        desc: "External Storage permission is required to in order to play local audios, which is the main purpose of this app.",
        style: AlertStyle(
          isOverlayTapDismiss: false,
          isCloseButton: false,
          titleStyle: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 2.75 * SizeConfig.textMultiplier
          ),
          descStyle: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 2 * SizeConfig.textMultiplier
          )
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Allow",
              style: Theme.of(context).textTheme.button.copyWith(
                fontSize: 2 * SizeConfig.textMultiplier
              ),
            ),
            onPressed: () {
              rqstPermission();
              Navigator.pop(context);
            },
            color: AppColors.secondaryColor,
            radius: BorderRadius.circular(SizeConfig.heightMultiplier),
          ),
        ]
    ).show();
  }
}
