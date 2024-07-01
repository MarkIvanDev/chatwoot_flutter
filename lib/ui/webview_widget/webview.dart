// import 'dart:convert';
// import 'dart:io';

// import 'package:chatwoot_flutter/chatwoot_flutter.dart';
// import 'package:chatwoot_flutter/ui/webview_widget/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:url_launcher/url_launcher.dart';

// ///Chatwoot webview widget
// /// {@category FlutterClientSdk}
// class Webview extends StatefulWidget {
//   /// Url for Chatwoot widget in webview
//   late final String widgetUrl;

//   /// Chatwoot user & locale initialisation script
//   late final String injectedJavaScript;

//   /// See [ChatwootWidget.closeWidget]
//   final void Function()? closeWidget;

//   /// See [ChatwootWidget.onAttachFile]
//   final Future<List<String>> Function()? onAttachFile;

//   /// See [ChatwootWidget.onLoadStarted]
//   final void Function()? onLoadStarted;

//   /// See [ChatwootWidget.onLoadProgress]
//   final void Function(int)? onLoadProgress;

//   /// See [ChatwootWidget.onLoadCompleted]
//   final void Function()? onLoadCompleted;

//   Webview(
//       {Key? key,
//       required String websiteToken,
//       required String baseUrl,
//       ChatwootUser? user,
//       String locale = "en",
//       customAttributes,
//       this.closeWidget,
//       this.onAttachFile,
//       this.onLoadStarted,
//       this.onLoadProgress,
//       this.onLoadCompleted})
//       : super(key: key) {
//     widgetUrl =
//         "${baseUrl}/widget?website_token=${websiteToken}&locale=${locale}";

//     injectedJavaScript = generateScripts(
//         user: user, locale: locale, customAttributes: customAttributes);
//   }

//   @override
//   _WebviewState createState() => _WebviewState();
// }

// class _WebviewState extends State<Webview> {
//   WebViewController? _controller;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       String webviewUrl = widget.widgetUrl;
//       final cwCookie = await StoreHelper.getCookie();
//       if (cwCookie.isNotEmpty) {
//         webviewUrl = "${webviewUrl}&cw_conversation=${cwCookie}";
//       }
//       setState(() {
//         _controller = WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setBackgroundColor(Colors.white)
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onProgress: (int progress) {
//                 // Update loading bar.
//                 widget.onLoadProgress?.call(progress);
//               },
//               onPageStarted: (String url) {
//                 widget.onLoadStarted?.call();
//               },
//               onPageFinished: (String url) async {
//                 widget.onLoadCompleted?.call();
//               },
//               onWebResourceError: (WebResourceError error) {},
//               onNavigationRequest: (NavigationRequest request) {
//                 _goToUrl(request.url);
//                 return NavigationDecision.prevent;
//               },
//             ),
//           )
//           ..addJavaScriptChannel("ReactNativeWebView",
//               onMessageReceived: (JavaScriptMessage jsMessage) {
//             print("Chatwoot message received: ${jsMessage.message}");
//             final message = getMessage(jsMessage.message);
//             if (isJsonString(message)) {
//               final parsedMessage = jsonDecode(message);
//               final eventType = parsedMessage["event"];
//               final type = parsedMessage["type"];
//               if (eventType == 'loaded') {
//                 final authToken = parsedMessage["config"]["authToken"];
//                 StoreHelper.storeCookie(authToken);
//                 _controller?.runJavaScript(widget.injectedJavaScript);
//               }
//               if (type == 'close-widget') {
//                 widget.closeWidget?.call();
//               }
//             }
//           })
//           ..loadRequest(Uri.parse(webviewUrl));

//         if (Platform.isAndroid && widget.onAttachFile != null) {
//           final androidController = _controller!.platform
//               as webview_flutter_android.AndroidWebViewController;
//           androidController
//               .setOnShowFileSelector((_) => widget.onAttachFile!.call());
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller != null
//         ? InAppWebView(
//             onLoadStop: (controller, url) {},
//           )
//         : SizedBox();
//   }

//   _goToUrl(String url) {
//     launchUrl(Uri.parse(url));
//   }
// }
