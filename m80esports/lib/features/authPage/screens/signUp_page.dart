import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/const_page.dart';
import '../../../core/globalVariables.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});
  @override
  State <SignUpPage> createState () => _SignUpPageState();
}
class _SignUpPageState extends State <SignUpPage>{
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: false,
              backgroundColor: ColorConst.secondaryColor,
              stretch: true,
              centerTitle: true,
              expandedHeight: h * 0.2,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Welcome to M80 Esports',style: textStyle(false)),
                centerTitle: true,
                titlePadding: EdgeInsets.only(bottom: h * 0.1),
              ),
            ),

            SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.all(w * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image(image: const AssetImage(ImageConst.logo),height: h * 0.3)),
                    SizedBox(height: h * 0.03),
                    TextFormField(
                      controller : nameController,
                      keyboardType: TextInputType.emailAddress,
                      style: textStyle(false),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(w * 0.03),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                            borderSide: const BorderSide(color: ColorConst.textColor)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                            borderSide: const BorderSide(color: ColorConst.textColor)
                        ),
                      ),
                    ),
                    SizedBox(height: h *0.01),
                    TextFormField(
                      controller : phoneNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 10,
                      style: textStyle(false),
                      decoration: InputDecoration(
                        counterText: '',
                        prefix: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: w * 0.03),
                          child: Text('+91',style: textStyle(false)),
                        ),
                        hintText: 'Enter your Mobile number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(w * 0.03),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                            borderSide: const BorderSide(color: ColorConst.textColor)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                            borderSide: const BorderSide(color: ColorConst.textColor)
                        ),
                      ),
                    ),
                    SizedBox(height: h *0.01),
                    InkWell(
                      onTap: () {
                        if(nameController.text.isEmpty){
                          toastMessage(
                              context: context,
                              label: 'Please enter your name!',
                              isSuccess: false);
                        }else if(phoneNumberController.text.isEmpty){
                          toastMessage(
                              context: context,
                              label: 'Please enter your Mobile number!',
                              isSuccess: false);
                        }else{
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                          toastMessage(context: context, label: 'Logged in successfully!', isSuccess: true);
                        }
                      },
                      child: Container(
                          width: w * 0.3,
                          height: h * 0.05,
                          decoration: BoxDecoration(
                              color: ColorConst.buttons,
                              borderRadius: BorderRadius.circular(w * 0.1)
                          ),
                          child: Center(child:Text('Sign Up',style: textStyle(false)))
                      ),
                    ),
                    SizedBox(height: h *0.01),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.back,color: ColorConst.textColor,size: w * 0.04),
                          const SizedBox(width: 10),
                          Text('Go back',style: textStyle(false)),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.2,)
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}