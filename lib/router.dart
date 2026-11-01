import 'package:go_router/go_router.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'products_page.dart';
import 'signup_page.dart';
import 'test.dart';

// Part 5.1 - ليه /signup top-level
// الـ redirect بيرجع أي path بيبدأ بـ /home على /login لو اليوزر مش عامل login.
// لو حطيت signup جوا /home هيبقى path بتاعه /home/signup، فالـ redirect هيمسكه
// ويرجعه لـ /login، واليوزر الجديد (اللي لسه معندوش account ومعملش login) عمره
// ما هيوصل لصفحة التسجيل. عشان كده لازم تبقى بره /home.
final router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    var path = state.matchedLocation;
    if (path.startsWith("/home") && !Database.isLoggedIn) {
      return "/login";
    }
    return null;
  },
  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductsPage(),
        ),
      ],
    ),
  ],
);

// Part 5.3 - نتايج التجارب
//
// Test 1 (push ثم pop): Signup فتحت فوق Login ولما عملت pop رجعت لـ Login
// نفس الصفحة، والنص اللي كنت كاتبه فيها لسه موجود.
//
// Test 2 (go ثم pop): الـ go شال Login وحط Signup لوحدها في الـ stack، فلما
// ندهت pop مكانش فيه حاجة تحتها ترجعلها. في الـ debug بيطلع error في الـ console
// (GoError: There is nothing to pop) والشاشة مبتتغيرش.
//
// Test 3 (go ثم go): اشتغل عادي. Login اتعملت من الأول (طلع "start Login" تاني)
// وSignup اتعمل لها dispose، يعني Login جديدة والنص القديم راح.
//
// Test 4 (push ثم سهم الرجوع): نفس نتيجة Test 1 لأن سهم الـ AppBar وزرار back
// بتاع الموبايل بينادوا pop لوحدهم، والـ stack فيها Login تحت Signup.
//
// بالنسبة للـ initState / dispose:
// - مع push: Login مبتتعملش dispose لما أفتح Signup، بتفضل عايشة تحت في الـ stack
//   ومفيش "finish Login".
// - مع go: Login بتتعمل dispose ويطلع "finish Login" لأن الـ stack اتبدل.
//
// Part 5.4 - الـ bug المخفي
// Login بتروح Home بـ go("/home") فالـ stack بقت فيها Home بس. زرار "go back"
// كان بينادي pop ومفيش حاجة تحت Home ترجعلها، فكان بيطلع نفس error الـ nothing to pop.
// الحل: حولته لزرار Logout بيخلي Database.isLoggedIn = false وبعدين go("/login").
//
// الفرق بين go و push
// push بيحط الصفحة الجديدة فوق الـ stack والصفحة القديمة بتفضل تحتها، وpop بيشيل
// اللي فوق ويرجعني للي تحتها. أما go فبيبدل الـ stack كلها بالصفحة الجديدة
// (والـ stack بتتبني من الـ path)، فمفيش حاجة تحتها أرجعلها.
