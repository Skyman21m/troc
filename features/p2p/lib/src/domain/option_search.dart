/// Whether [name] matches the text [query] typed in a list's search field, as the official client's payment method list filters its options (`AutocompletePayments.tsx`, `useAutocomplete` with its default `filterOptions`, MUI's `createFilterOptions()`): the name contains the text anywhere, case and accents ignored, the text taken as typed (MUI's `trim` is off by default).
///
/// An empty text matches every name.
bool matchesOptionSearch(String name, String query) =>
    foldForSearch(name).contains(foldForSearch(query));

/// [text] in lower case without its accents, as MUI compares an option with what is typed (`toLowerCase`, then `normalize('NFD')` with the combining marks removed).
///
/// Dart has no Unicode normalization, and the feature takes no dependency for it: the letters with an accent of Latin-1 and Latin Extended-A are mapped to their base letter, which covers the names of the official list and what a French, Spanish, Portuguese, German or Polish keyboard types; letters with no decomposition (« ø », « ł », « œ », « ß ») stay as they are, as with NFD, and other scripts are only lower-cased.
String foldForSearch(String text) {
  final lower = text.toLowerCase();
  final folded = StringBuffer();
  for (final rune in lower.runes) {
    if (rune >= 0x0300 && rune <= 0x036F) continue;
    folded.write(_bases[rune] ?? String.fromCharCode(rune));
  }
  return folded.toString();
}

/// Each lower-case letter with an accent, by code point, and its base letter; « İ » lower-cases to « i » and a combining dot, which [foldForSearch] drops.
final Map<int, String> _bases = {
  for (final (letters, base) in const [
    ('àáâãäåāăą', 'a'),
    ('çćĉċč', 'c'),
    ('ď', 'd'),
    ('èéêëēĕėęě', 'e'),
    ('ĝğġģ', 'g'),
    ('ĥ', 'h'),
    ('ìíîïĩīĭį', 'i'),
    ('ĵ', 'j'),
    ('ķ', 'k'),
    ('ĺļľ', 'l'),
    ('ñńņň', 'n'),
    ('òóôõöōŏő', 'o'),
    ('ŕŗř', 'r'),
    ('śŝşš', 's'),
    ('ţť', 't'),
    ('ùúûüũūŭůűų', 'u'),
    ('ŵ', 'w'),
    ('ýÿŷ', 'y'),
    ('źżž', 'z'),
  ])
    for (final rune in letters.runes) rune: base,
};
