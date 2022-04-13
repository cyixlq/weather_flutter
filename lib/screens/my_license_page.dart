
import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';

class MyLicensePage extends StatelessWidget {

  final String? applicationName;
  final String? applicationVersion;
  final Widget? applicationIcon;
  final String? applicationLegalese;


  const MyLicensePage({
    Key? key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: windowsBg,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).padding.left,
        right: MediaQuery.of(context).padding.right,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: LicensePage(
        applicationName: applicationName,
        applicationVersion: applicationVersion,
        applicationIcon: applicationIcon,
        applicationLegalese: applicationLegalese,
      ),
    );
  }
}
