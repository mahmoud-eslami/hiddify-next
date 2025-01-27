import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hiddify/core/core_providers.dart';
import 'package:hiddify/domain/app/app.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO add release notes
class NewVersionDialog extends HookConsumerWidget with PresLogger {
  NewVersionDialog(
    this.currentVersion,
    this.newVersion, {
    // super.key,
    this.canIgnore = true,
  }) : super(key: _dialogKey);

  final String currentVersion;
  final RemoteVersionInfo newVersion;
  final bool canIgnore;

  static final _dialogKey = GlobalKey(debugLabel: 'new version dialog');

  Future<void> show(BuildContext context) async {
    if (_dialogKey.currentContext == null) {
      return showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => this,
      );
    } else {
      loggy.warning("new version dialog is already open");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(t.appUpdate.dialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.appUpdate.updateMsg),
          const Gap(8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${t.appUpdate.currentVersionLbl}: ",
                  style: theme.textTheme.bodySmall,
                ),
                TextSpan(
                  text: currentVersion,
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${t.appUpdate.newVersionLbl}: ",
                  style: theme.textTheme.bodySmall,
                ),
                TextSpan(
                  text: newVersion.presentVersion,
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (canIgnore)
          TextButton(
            onPressed: () {
              // TODO add prefs for ignoring version
              context.pop();
            },
            child: Text(t.appUpdate.ignoreBtnTxt),
          ),
        TextButton(
          onPressed: context.pop,
          child: Text(t.appUpdate.laterBtnTxt),
        ),
        TextButton(
          onPressed: () async {
            await UriUtils.tryLaunch(Uri.parse(newVersion.url));
          },
          child: Text(t.appUpdate.updateNowBtnTxt),
        ),
      ],
    );
  }
}
