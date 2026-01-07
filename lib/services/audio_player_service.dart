import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:driver/utils/preferences.dart';

class AudioPlayerService {
  static late AudioPlayer _audioPlayer;

  static initAudio() async {
    _audioPlayer = AudioPlayer(playerId: "playerId");
  }

  static Future<void> playSound(bool isPlay) async {
    try {
      if (isPlay) {
        log("PlaySound :: 11 :: $isPlay :: ${Preferences.getString(Preferences.orderRingtone)}");
        if (_audioPlayer.state != PlayerState.playing) {
          await _audioPlayer.setSource(
              UrlSource(Preferences.getString(Preferences.orderRingtone)));
          await _audioPlayer.setReleaseMode(ReleaseMode.loop);
          await _audioPlayer.resume();
        }
      } else {
        log("PlaySound :: 22 :: $isPlay :: ${Preferences.getString(Preferences.orderRingtone)}");
        if (_audioPlayer.state != PlayerState.stopped) {
          await _audioPlayer.stop();
        }
      }
    } catch (e) {
      print("Error in playSound: $e");
    }
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

