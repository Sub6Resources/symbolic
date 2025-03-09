import 'package:symbolic/core/facts.dart' show generateFactRules;
import 'dart:io';

void main() async {
  final representation = generateFactRules().toDart();
  final code = """
// Do NOT manually edit this file.
// Instead, run `bin/ask_update.dart`.

$representation  
""";

  final file = File("lib/core/assumptions_generated.dart").openWrite();
  file.write(code);
  await file.flush();
  await file.close();
}
