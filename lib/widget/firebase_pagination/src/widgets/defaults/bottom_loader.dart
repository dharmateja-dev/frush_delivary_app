// Flutter Packages
import 'package:flutter/material.dart';

/// A circular progress indicator that spins when the [Stream] is loading.
///
/// Used at the bottom of a [ScrollView] to indicate that more data is loading.
class BottomLoader extends StatelessWidget {
  /// Creates a circular progress indicator that spins when the [Stream] is
  /// loading.
  ///
  /// Used at the bottom of a [ScrollView] to indicate that more data is
  /// loading.
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 25,
        height: 25,
        margin: const EdgeInsets.all(10),
        child: const CircularProgressIndicator.adaptive(
          strokeWidth: 2.5,
        ),
      ),
    );
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

