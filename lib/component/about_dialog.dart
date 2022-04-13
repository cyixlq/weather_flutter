
import 'package:flutter/material.dart';
import 'package:weather_flutter/common/navigator_util.dart';
import 'package:weather_flutter/screens/my_license_page.dart';

class MyAboutDialog extends StatelessWidget {

  static const double _textVerticalSeparation = 18.0;

  final String? applicationName;
  final String? applicationVersion;
  final Widget? applicationIcon;
  final String? applicationLegalese;
  final List<Widget>? children;

  const MyAboutDialog({
    Key? key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = applicationName ?? '';
    final String version = applicationVersion ?? '';
    final Widget? icon = applicationIcon ?? const SizedBox();
    return AlertDialog(
      content: ListBody(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (icon != null) IconTheme(data: Theme.of(context).iconTheme, child: icon),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListBody(
                    children: <Widget>[
                      Text(name, style: Theme.of(context).textTheme.headline5),
                      Text(version, style: Theme.of(context).textTheme.bodyText2),
                      const SizedBox(height: _textVerticalSeparation),
                      Text(applicationLegalese ?? '', style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ...?children,
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('查看许可证'),
          onPressed: () {
            NavigatorUtil.pop(context);
            NavigatorUtil.push(context, MyLicensePage(
              applicationName: applicationName,
              applicationVersion: applicationVersion,
              applicationIcon: applicationIcon,
              applicationLegalese: applicationLegalese,
            ));
          },
        ),
        TextButton(
          child: const Text('关闭'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      scrollable: true,
    );
  }
}
