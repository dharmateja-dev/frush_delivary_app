import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:driver/app/auth_screen/signup_screen.dart';
import 'package:driver/app/dash_board_screen/dash_board_screen.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordEditingController =
      TextEditingController().obs;

  RxBool passwordVisible = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  loginWithEmailAndPassword() async {
    ShowToastDialog.showLoader("Please wait.".tr);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailEditingController.value.text.trim(),
        password: passwordEditingController.value.text.trim(),
      );
      // final user = credential.user;

      // if (user != null && !user.emailVerified) {
      //   await FirebaseAuth.instance.signOut();
      //   ShowToastDialog.closeLoader();
      //   ShowToastDialog.showToast(
      //       "Please verify your email before logging in.");
      //   return;
      // }
      UserModel? userModel =
          await FireStoreUtils.getUserProfile(credential.user!.uid);
      if (userModel?.role == Constant.userRoleDriver) {
        if (userModel?.active == true) {
          userModel?.fcmToken = await NotificationService.getToken();
          await FireStoreUtils.updateUser(userModel!);
          Get.offAll(const DashBoardScreen());
        } else {
          await FirebaseAuth.instance.signOut();
          ShowToastDialog.showToast(
              "This user is disable please contact to administrator".tr);
        }
      } else {
        await FirebaseAuth.instance.signOut();
        ShowToastDialog.showToast(
            "This user is not created in driver application.".tr);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        ShowToastDialog.showToast("No user found for that email.".tr);
      } else if (e.code == 'wrong-password') {
        ShowToastDialog.showToast("Wrong password provided for that user.".tr);
      } else if (e.code == 'invalid-email') {
        ShowToastDialog.showToast("Invalid Email.".tr);
      } else {
        ShowToastDialog.showToast("${e.message}");
      }
    }
    ShowToastDialog.closeLoader();
  }

  loginWithGoogle() async {
    ShowToastDialog.showLoader("please wait...".tr);
    try {
      final UserCredential? userCredential = await signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        String userId = userCredential.user!.uid;

        // Check if user exists in Firestore
        bool userExists = await FireStoreUtils.userExistOrNot(userId);

        if (userExists) {
          // User exists, get their profile
          UserModel? userModel = await FireStoreUtils.getUserProfile(userId);

          if (userModel != null) {
            if (userModel.role == Constant.userRoleVendor) {
              if (userModel.active == true) {
                // Update FCM token and navigate to dashboard
                userModel.fcmToken = await NotificationService.getToken();
                await FireStoreUtils.updateUser(userModel);
                ShowToastDialog.closeLoader();
                Get.offAll(const DashBoardScreen());
              } else {
                // User is disabled
                await FirebaseAuth.instance.signOut();
                ShowToastDialog.closeLoader();
                ShowToastDialog.showToast(
                    "This user is disable please contact to administrator".tr);
              }
            } else {
              // User exists but doesn't have vendor role
              // Instead of showing error and signing out, let's update the role
              userModel.role = Constant.userRoleVendor; // Set vendor role
              userModel.active = true; // Make sure account is active
              userModel.fcmToken = await NotificationService.getToken();

              // Update user in Firestore with vendor role
              await FireStoreUtils.updateUser(userModel);
              ShowToastDialog.closeLoader();
              Get.offAll(const DashBoardScreen());
            }
          } else {
            // User exists but profile couldn't be fetched
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast("Failed to load user profile".tr);
          }
        } else {
          // New user, create profile
          UserModel userModel = UserModel();
          userModel.id = userId;
          userModel.email = userCredential.user!.email;
          userModel.firstName =
              userCredential.user!.displayName?.split(' ').first;
          userModel.lastName =
              userCredential.user!.displayName?.split(' ').last;
          userModel.provider = 'google';

          ShowToastDialog.closeLoader();
          Get.off(const SignupScreen(), arguments: {
            "userModel": userModel,
            "type": "google",
          });
        }
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Failed to sign in with Google".tr);
    }
  }

  loginWithApple() async {
    ShowToastDialog.showLoader("please wait...".tr);
    await signInWithApple().then((value) async {
      ShowToastDialog.closeLoader();
      if (value != null) {
        Map<String, dynamic> map = value;
        AuthorizationCredentialAppleID appleCredential = map['appleCredential'];
        UserCredential userCredential = map['userCredential'];
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = userCredential.user!.uid;
          userModel.email = appleCredential.email;
          userModel.firstName = appleCredential.givenName;
          userModel.lastName = appleCredential.familyName;
          userModel.provider = 'apple';

          ShowToastDialog.closeLoader();
          Get.off(const SignupScreen(), arguments: {
            "userModel": userModel,
            "type": "apple",
          });
        } else {
          await FireStoreUtils.userExistOrNot(userCredential.user!.uid)
              .then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              UserModel? userModel =
                  await FireStoreUtils.getUserProfile(userCredential.user!.uid);
              if (userModel!.role == Constant.userRoleVendor) {
                if (userModel.active == true) {
                  userModel.fcmToken = await NotificationService.getToken();
                  await FireStoreUtils.updateUser(userModel);
                  Get.offAll(const DashBoardScreen());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast(
                      "This user is disable please contact to administrator"
                          .tr);
                }
              } else {
                await FirebaseAuth.instance.signOut();
                // ShowToastDialog.showToast("This user is disable please contact to administrator".tr);
              }
            } else {
              UserModel userModel = UserModel();
              userModel.id = userCredential.user!.uid;
              userModel.email = appleCredential.email;
              userModel.firstName = appleCredential.givenName;
              userModel.lastName = appleCredential.familyName;
              userModel.provider = 'apple';

              Get.off(const SignupScreen(), arguments: {
                "userModel": userModel,
                "type": "apple",
              });
            }
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("=== GOOGLE SIGN IN DEBUG ===");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("Step 1 - GoogleUser: $googleUser");

      if (googleUser == null) {
        print("User cancelled");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print("Step 2 - Auth tokens obtained");
      print("ID Token: ${googleAuth.idToken?.substring(0, 20)}...");
      print("Access Token: ${googleAuth.accessToken?.substring(0, 20)}...");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("Step 3 - Credential created");

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Step 4 - Firebase auth successful");
      print("User: ${result.user?.email}");

      return result;
    } catch (e, stackTrace) {
      print("=== ERROR DETAILS ===");
      print("Error type: ${e.runtimeType}");
      print("Error: $e");
      print("Stack: $stackTrace");

      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Debug Error: $e");
      return null;
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return {
        "appleCredential": appleCredential,
        "userCredential": userCredential
      };
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

/*******************************************************************************************
* Copyright (c) 2025 Movenetics Digital. All rights reserved.
*
* This software and associated documentation files are the property of 
* Movenetics Digital. Unauthorized copying, modification, distribution, or use of this 
* Software, via any medium, is strictly prohibited without prior written permission.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
* OTHER DEALINGS IN THE SOFTWARE.
*
* Company: Movenetics Digital
* Author: Aman Bhandari 
*******************************************************************************************/

