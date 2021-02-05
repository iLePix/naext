import 'package:naext/api/naext_api.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:naext/models/version.dart';
import 'package:naext/api/naext_api.dart';
import 'package:naext/blocs/bloc_base.dart';

class AppVersionBloc extends BlocBase {

  NaextApi _naextApi = NaextApi();

  BehaviorSubject<bool> _versionController = BehaviorSubject<bool>();
  BehaviorSubject<bool> _gtcController = BehaviorSubject<bool>();

  Stream<bool> get requiresUpdate => _versionController.stream;
  Stream<bool> get newGTCs => _gtcController.stream;


  Future<void> checkForNewVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    print("App-Name : " + packageInfo.appName + " Package-Name : " + packageInfo.packageName + " App-Version : " + packageInfo.version + " App-Build-Number : " + packageInfo.buildNumber);
    List<String> installedAppVersion = packageInfo.version.split(".");
    try {
      _naextApi.appRequiredVersion().then((Version requiredAppVersion) {
        print(requiredAppVersion.toString());
        if (requiredAppVersion.major > int.parse(installedAppVersion[0])) {
          _versionController.sink.add(true);
        } else {
          if (requiredAppVersion.minor > int.parse(installedAppVersion[1])) {
            _versionController.sink.add(true);
          } else {
            if (requiredAppVersion.patch > int.parse(installedAppVersion[2])) {
              _versionController.sink.add(true);
            }
          }
        }

      });
    } catch(err) {
      print(err);
    }
  }

  @override
  void dispose() {
    _versionController?.close();
    _gtcController?.close();
  }

}