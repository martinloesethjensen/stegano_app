import 'package:stegano_app/app/app.dart';
import 'package:stegano_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
