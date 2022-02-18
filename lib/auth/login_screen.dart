import 'package:cached_network_image/cached_network_image.dart';
import 'package:seller_central_eatzy/screens/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class ColorUtils {
  static const Color primaryColor = Color(0xffEC9F05);
  static const Color accentColor = Color(0xffFF4E00);
  static const Color orangeGradientEnd = Color(0xfffc4a1a);
  static const Color orangeGradientStart = Color(0xfff7b733);
  static const Color themeGradientStart = Color(0xFF3F6856);
  static const Color themeGradientEnd = Color(0xFFF8FDFD);
  static const LinearGradient appBarGradient =
  LinearGradient(colors: [themeGradientStart, themeGradientEnd]);
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: double.infinity,
                decoration: BoxDecoration(gradient: ColorUtils.appBarGradient),
              ),
              const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w800,
                          fontSize: 19),
                    ),
                  )),
              Positioned(
                top: 150,
                left: 10,
                right: 10,
                child: LoginFormWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormWidgetState();
  }
}

class _LoginFormWidgetState extends State<LoginFormWidget>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
  }

  final _formKey = GlobalKey<FormState>();
  var _userEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ScaleTransition(
            scale: animation,
            child: Opacity(
              opacity: _opacity,
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        _buildLogo(),
                        _buildIntroText(),
                        _buildPhoneField(context),
                        _buildSpacer(context),
                        _buildSocialLoginRow(context),
                      ],
                    ),
                  ),
                  _buildSignUp(),
                ],
              ),
            )));
  }

  Widget _buildSpacer(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
        child: Text(
          "OR",
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildSocialLoginRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      child: Row(
        children: <Widget>[__buildGoogleButtonWidget(context)],
      ),
    );
  }

  Widget __buildGoogleButtonWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: SignInButton(Buttons.Google,
              elevation: 1.0, text: "Sign In with Google", onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => BottomBar()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)))),
    );
  }

  Widget _buildIntroText() {
    return Column(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 30),
          child: Text(
            "Snap a2z easily",
            style: TextStyle(
                color: Color(0xff3e716d),
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CachedNetworkImage(
          height: 100, width: 100,
          imageUrl: "https://eatzy-outlets.s3.amazonaws.com/g/icon/ScanBanner.png",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter:
                  ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
  }

  setPhoneNumber() {}

  Widget _buildPhoneField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
      child: TextField(
          controller: _userEmailController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            hintText: 'Sign In With Phone Number',
            suffixIcon: IconButton(
              onPressed: () async {
                setPhoneNumber();
              },
              icon: const Icon(Icons.phonelink_setup),
            ),
          )),
    );
  }

  Widget _buildSignUp() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: const <TextSpan>[
            TextSpan(
              text: '@atzy.in',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black38,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Function onPressed;

  RaisedGradientButton({
    Key? key,
    required this.child,
    this.width = double.infinity,
    this.height = 40.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Gradient _gradient = const LinearGradient(
        colors: [ColorUtils.themeGradientStart, ColorUtils.themeGradientEnd]);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(40.0)),
          gradient: _gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500]!,
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: new BorderRadius.all(Radius.circular(40.0)),
            onTap: () {},
            child: Center(
              child: child,
            )),
      ),
    );
  }
}

class CommonStyles {
  static textFormFieldStyle(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      labelStyle: const TextStyle(color: Colors.black),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
    );
  }
}
