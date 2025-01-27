import 'package:flutter/material.dart';
import 'package:hiddify/core/core_providers.dart';
import 'package:hiddify/core/router/router.dart';
import 'package:hiddify/features/common/stats/stats_overview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DesktopWrapper extends HookConsumerWidget {
  const DesktopWrapper(this.navigator, {super.key});

  final Widget navigator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    final currentIndex = getCurrentIndex(context);

    final destinations = [
      NavigationRailDestination(
        icon: const Icon(Icons.power_settings_new),
        label: Text(t.home.pageTitle),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.filter_list),
        label: Text(t.proxies.pageTitle),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.article),
        label: Text(t.logs.pageTitle),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.settings),
        label: Text(t.settings.pageTitle),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.info),
        label: Text(t.about.pageTitle),
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 192,
            child: NavigationRail(
              extended: true,
              minExtendedWidth: 192,
              destinations: destinations,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) => switchTab(index, context),
              trailing: const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: StatsOverview(),
                ),
              ),
            ),
          ),
          Expanded(child: navigator),
        ],
      ),
    );
  }
}
