
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {

  final String text;
  const LoadingDialog({Key? key, this.text = '请稍候...'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      constrainedAxis: Axis.vertical,
      child: SizedBox(
        width: 250,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Color(0xff3399ff))
              ),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text(text),
              )
            ],
          ),
        ),
      ),
    );
  }
}
