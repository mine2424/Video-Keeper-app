import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TimerDialog extends StatefulWidget {
  @override
  State createState() => TimerDialogState();
}

class TimerDialogState extends State<TimerDialog> {
  Duration timerDuration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> actions = [
      CupertinoActionSheetAction(
        child: Text(localizations.okButtonLabel),
        onPressed: () {
          Navigator.pop<Duration>(context, timerDuration);
        },
      ),
    ];

    final actionSheet = CupertinoActionSheet(
      title: Text("Set Timer"),
      message: CupertinoTimerPicker(
        onTimerDurationChanged: (newDuration) => timerDuration = newDuration,
      ),
      actions: actions,
      cancelButton: CupertinoActionSheetAction(
        child: Text(localizations.cancelButtonLabel),
        onPressed: () => Navigator.pop(context),
      ),
    );

    return actionSheet;
  }
}

Future<Duration> showTimerDialog({
  @required BuildContext context,
  TransitionBuilder builder,
  bool useRootNavigator = true,
}) {
  final Widget dialog = TimerDialog();
  return showCupertinoModalPopup(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}
