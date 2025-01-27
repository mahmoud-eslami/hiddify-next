import 'package:flutter_test/flutter_test.dart';
import 'package:hiddify/domain/profiles/profiles.dart';

void main() {
  const validBaseUrl = "https://example.com/configurations/user1/filename.yaml";
  const validExtendedUrl =
      "https://example.com/configurations/user1/filename.yaml?test#b";
  const validSupportUrl = "https://example.com/support";

  group(
    "profile fromResponse",
    () {
      test(
        "with no additional metadata",
        () {
          final profile = Profile.fromResponse(validExtendedUrl, {});

          expect(profile.name, equals("filename"));
          expect(profile.url, equals(validExtendedUrl));
          expect(profile.options, isNull);
          expect(profile.subInfo, isNull);
        },
      );

      test(
        "with all metadata",
        () {
          final headers = <String, List<String>>{
            // decoded: exampleTitle
            "profile-title": ["base64:ZXhhbXBsZVRpdGxl"],
            "profile-update-interval": ["1"],
            // expire: 2024/1/1
            "subscription-userinfo": [
              "upload=0;download=1024;total=10240;expire=1704054600",
            ],
            "profile-web-page-url": [validBaseUrl],
            "support-url": [validSupportUrl],
          };
          final profile = Profile.fromResponse(validExtendedUrl, headers);

          expect(profile.name, equals("exampleTitle"));
          expect(profile.url, equals(validExtendedUrl));
          expect(
            profile.options,
            equals(const ProfileOptions(updateInterval: Duration(hours: 1))),
          );
          expect(
            profile.subInfo,
            equals(
              SubscriptionInfo(
                upload: 0,
                download: 1024,
                total: 10240,
                expire: DateTime(2024),
                webPageUrl: validBaseUrl,
                supportUrl: validSupportUrl,
              ),
            ),
          );
        },
      );
    },
  );
}
