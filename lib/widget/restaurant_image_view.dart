import 'dart:async';

import 'package:driver/models/vendor_model.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';

class RestaurantImageView extends StatefulWidget {
  final VendorModel vendorModel;

  const RestaurantImageView({super.key, required this.vendorModel});

  @override
  State<RestaurantImageView> createState() => _RestaurantImageViewState();
}

class _RestaurantImageViewState extends State<RestaurantImageView> {
  int currentPage = 0;

  PageController pageController = PageController(initialPage: 1);

  @override
  void initState() {
    animateSlider();
    super.initState();
  }

  void animateSlider() {
    if (widget.vendorModel.photos != null && widget.vendorModel.photos!.isNotEmpty) {
      Timer.periodic(const Duration(seconds: 2), (Timer timer) {
        if (currentPage < widget.vendorModel.photos!.length) {
          currentPage++;
        } else {
          currentPage = 0;
        }

        if (pageController.hasClients) {
          pageController.animateToPage(
            currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.height(20, context),
      child: widget.vendorModel.photos == null || widget.vendorModel.photos!.isEmpty
          ? NetworkImageWidget(
              imageUrl: widget.vendorModel.photo.toString(),
              fit: BoxFit.cover,
              height: Responsive.height(20, context),
              width: Responsive.width(100, context),
            )
          : PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: pageController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.vendorModel.photos!.length,
              padEnds: false,
              pageSnapping: true,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                String image = widget.vendorModel.photos![index];
                return NetworkImageWidget(
                  imageUrl: image.toString(),
                  fit: BoxFit.cover,
                  height: Responsive.height(20, context),
                  width: Responsive.width(100, context),
                );
              },
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

