import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watchlist/core/data/drama_data.dart';
import 'package:watchlist/core/layout/breakpoints.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/core/theme/app_theme.dart';
import 'package:watchlist/features/home /presentation/detail_screen.dart';
import 'package:watchlist/features/home /presentation/filter_screen.dart';
import 'package:watchlist/features/home /presentation/home_screen.dart';
import 'package:watchlist/features/home /widgets/drama_card.dart';

const Size kSmallPhone = Size(320, 568);
const Size kLargePhone = Size(430, 932);
const Size kTablet = Size(800, 1280);

Future<void> pumpAt(
  WidgetTester tester,
  Size size, {
  List<Drama>? dramas,
  double keyboard = 0,
  bool filter = false,
}) async {
  final data = dramas ?? kDramas;

  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: filter ? FilterScreen(dramas: data) : HomeScreen(dramas: data),
    ),
  );
  await tester.pumpAndSettle();
}

void expectHealthyLayout(WidgetTester tester, Size size,
    {bool filter = false}) {
  expect(tester.takeException(), isNull);

  final wide = size.width >= kTabletBreakpoint;
  final tablet = Key(filter ? 'filter-tablet-layout' : 'tablet-layout');
  final phone = Key(filter ? 'filter-phone-layout' : 'phone-layout');

  expect(find.byKey(tablet), wide ? findsOneWidget : findsNothing);
  expect(find.byKey(phone), wide ? findsNothing : findsOneWidget);
}

Future<void> openFirstCard(WidgetTester tester) async {
  final card = find.byType(DramaCard).first;
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tap(card);
  await tester.pumpAndSettle();
}

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('1 · Small phone, 320 dp', () {
    testWidgets('home: no overflow, phone layout', (tester) async {
      await pumpAt(tester, kSmallPhone);
      expectHealthyLayout(tester, kSmallPhone);
    });

    testWidgets('filter: no overflow, phone layout', (tester) async {
      await pumpAt(tester, kSmallPhone, filter: true);
      expectHealthyLayout(tester, kSmallPhone, filter: true);
    });
  });

  group('2 · Large phone, 430 dp', () {
    testWidgets('home: no overflow, phone layout', (tester) async {
      await pumpAt(tester, kLargePhone);
      expectHealthyLayout(tester, kLargePhone);
    });

    testWidgets('filter: no overflow, phone layout', (tester) async {
      await pumpAt(tester, kLargePhone, filter: true);
      expectHealthyLayout(tester, kLargePhone, filter: true);
    });
  });

  group('3 · Tablet, 800 dp', () {
    testWidgets('home: layout changes to side panel + grid', (tester) async {
      await pumpAt(tester, kTablet);
      expectHealthyLayout(tester, kTablet);
    });

    testWidgets('filter: layout changes to side panel + grid', (tester) async {
      await pumpAt(tester, kTablet, filter: true);
      expectHealthyLayout(tester, kTablet, filter: true);
    });
  });

  group('4 · Landscape, all three', () {
    final sizes = <String, Size>{
      'small phone, 568 x 320': kSmallPhone.flipped,
      'large phone, 932 x 430': kLargePhone.flipped,
      'tablet, 1280 x 800': kTablet.flipped,
    };

    for (final e in sizes.entries) {
      testWidgets('home, ${e.key}', (tester) async {
        await pumpAt(tester, e.value);
        expectHealthyLayout(tester, e.value);
      });

      testWidgets('filter, ${e.key}', (tester) async {
        await pumpAt(tester, e.value, filter: true);
        expectHealthyLayout(tester, e.value, filter: true);
      });
    }
  });

  group('5 · A 200-character name', () {
    test('test data is exactly 200 characters', () {
      expect(kLongName.length, 200);
    });

    testWidgets('home: title and subtitle are truncated, no overflow',
        (tester) async {
      await pumpAt(tester, kSmallPhone, dramas: kLongNameDramas);

      final title = find.descendant(
          of: find.byType(DramaCard), matching: find.text(kLongName));
      await tester.scrollUntilVisible(
        title,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      final widget = tester.widget<Text>(title);
      expect(widget.maxLines, isNotNull);
      expect(widget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('filter: long trope chip does not overflow', (tester) async {
      await pumpAt(tester, kSmallPhone, dramas: kLongNameDramas, filter: true);

      expect(tester.takeException(), isNull);
      expect(find.text(kLongTrope), findsOneWidget);
    });
  });

  group('6 · Zero items', () {
    testWidgets('home: empty state has an icon, a message and an action',
        (tester) async {
      await pumpAt(tester, kSmallPhone, dramas: kEmptyDramas);

      final empty = find.byKey(const Key('empty-state'));
      expect(tester.takeException(), isNull);
      expect(empty, findsOneWidget);
      expect(find.descendant(of: empty, matching: find.byType(Icon)),
          findsOneWidget);
      expect(find.text('Your watchlist is empty'), findsOneWidget);
      expect(find.descendant(of: empty, matching: find.byType(FilledButton)),
          findsOneWidget);
    });

    testWidgets('filter: no match shows empty state; Clear filters recovers',
        (tester) async {
      await pumpAt(tester, kLargePhone, filter: true);

      await tester.enterText(find.byKey(const Key('search-field')), 'zzzzzz');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty-state')), findsOneWidget);
      expect(find.text('No dramas found'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty-state')), findsNothing);
      expect(find.text(kDramas.first.title), findsOneWidget);
    });
  });

  group('7 · 500 items', () {
    testWidgets('home: list is lazy, only a few cards are built',
        (tester) async {
      await pumpAt(tester, kLargePhone, dramas: kBigDramas);

      expect(tester.takeException(), isNull);
      expect(find.byType(SliverGrid), findsOneWidget);
      expect(find.byType(DramaCard).evaluate().length, lessThan(100));
    });

    testWidgets('home: scrolls to the last item without errors',
        (tester) async {
      await pumpAt(tester, kLargePhone, dramas: kBigDramas);

      await tester.scrollUntilVisible(
        find.text('Drama #500'),
        3000,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 200,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Drama #500'), findsOneWidget);
    });
  });

  group('8 · Keyboard open', () {
    testWidgets('filter: search field stays visible on a short screen',
        (tester) async {
      const size = Size(568, 320); // 320 dp landscape
      const keyboard = 180.0;

      await pumpAt(tester, size, filter: true);
      await tester.tap(find.byKey(const Key('search-field')));
      await tester.pumpAndSettle();

      // Keyboard muncul.
      tester.view.viewInsets = const FakeViewPadding(bottom: keyboard);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('search-field')), 'love');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      final rect = tester.getRect(find.byKey(const Key('search-field')));
      expect(rect.top, greaterThanOrEqualTo(0));
      expect(rect.bottom, lessThanOrEqualTo(size.height - keyboard + 1));
    });
  });

  group('9 · Dark mode', () {
    testWidgets('dark theme is active, no overflow', (tester) async {
      await pumpAt(tester, kLargePhone);

      expect(tester.takeException(), isNull);
      final ctx = tester.element(find.byType(HomeScreen));
      expect(Theme.of(ctx).brightness, Brightness.dark);
    });

    testWidgets('text keeps enough contrast (4.5:1)', (tester) async {
      await pumpAt(tester, kLargePhone);

      final ctx = tester.element(find.byType(HomeScreen));
      final scheme = Theme.of(ctx).colorScheme;

      // Teks isi di atas card.
      expect(contrast(scheme.onSurface, AppTheme.cardColor),
          greaterThanOrEqualTo(4.5));

      // Teks gelap di atas badge status dan warna aksen.
      for (final c in [
        AppTheme.watchingColor,
        AppTheme.completedColor,
        AppTheme.planColor,
        AppTheme.accentColor,
      ]) {
        expect(contrast(AppTheme.onAccent, c), greaterThanOrEqualTo(4.5));
      }
    });
  });

  group('10 · Detail screen', () {
    testWidgets('small phone: opens from a card, no overflow',
        (tester) async {
      await pumpAt(tester, kSmallPhone);
      await openFirstCard(tester);

      expect(tester.takeException(), isNull);
      expect(find.byType(DetailScreen), findsOneWidget);
      expect(find.byKey(const Key('detail-phone-layout')), findsOneWidget);
    });

    testWidgets('tablet: layout changes to poster + info', (tester) async {
      await pumpAt(tester, kTablet);
      await openFirstCard(tester);

      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('detail-tablet-layout')), findsOneWidget);
      expect(find.byKey(const Key('detail-phone-layout')), findsNothing);
    });

    testWidgets('landscape phone: no overflow', (tester) async {
      await pumpAt(tester, kSmallPhone.flipped);
      await openFirstCard(tester);

      expect(tester.takeException(), isNull);
      expect(find.byType(DetailScreen), findsOneWidget);
    });

    testWidgets('200-character name: no overflow', (tester) async {
      await pumpAt(tester, kSmallPhone, dramas: kLongNameDramas);
      await openFirstCard(tester);

      expect(tester.takeException(), isNull);
      expect(find.byType(DetailScreen), findsOneWidget);
      expect(find.text(kLongName), findsOneWidget);
    });
  });
}