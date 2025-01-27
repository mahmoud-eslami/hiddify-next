import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hiddify/core/prefs/prefs.dart';
import 'package:hiddify/domain/connectivity/connection_failure.dart';

part 'connection_status.freezed.dart';

@freezed
sealed class ConnectionStatus with _$ConnectionStatus {
  const ConnectionStatus._();

  const factory ConnectionStatus.disconnected([
    ConnectionFailure? connectionFailure,
  ]) = Disconnected;
  const factory ConnectionStatus.connecting() = Connecting;
  const factory ConnectionStatus.connected() = Connected;
  const factory ConnectionStatus.disconnecting() = Disconnecting;

  bool get isConnected => switch (this) { Connected() => true, _ => false };

  bool get isSwitching => switch (this) {
        Connecting() => true,
        Disconnecting() => true,
        _ => false,
      };

  String present(TranslationsEn t) => switch (this) {
        Disconnected() => t.home.connection.tapToConnect,
        Connecting() => t.home.connection.connecting,
        Connected() => t.home.connection.connected,
        Disconnecting() => t.home.connection.disconnecting,
      };
}
