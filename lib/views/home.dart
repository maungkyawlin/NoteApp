import 'package:calendar/database/note_table.dart';
import 'package:calendar/database/notedao.dart';
import 'package:calendar/views/add_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Helper/notification.dart';
import '../Helper/theme_service.dart';

import '../utils/dimensions.dart';

import 'note_details.dart';
import 'search_page.dart';
import 'update_screen.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home(NoteDao noteDao, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    setState(() {
      print("I am Here");
    });
  }

  // ignore: use_key_in_widget_constructors
  final NoteDao noteDao = Get.find();

  List<Note> notes = [];
  List<bool> checked = [false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        width: MediaQuery.of(context).size.width / 2,
        elevation: 8.0,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(
                    left: 10, top: 5, bottom: 5, right: 5),
                child: Image.asset(
                  "assets/images/logo.webp",
                  width: 100,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "NoteApp",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              height: Dimensions.height30,
            ),
            TextButton(
                onPressed: () {
                  Get.to(() => const AddScreen());
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 30,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                    SizedBox(
                      width: Dimensions.height15,
                    ),
                    Text(
                      "ပေါင်းထည့်ရန်",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                )),
            TextButton(
              onPressed: () {
                _deleteAllNote(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 30,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(
                    width: Dimensions.height15,
                  ),
                  Text(
                    'အားလုံးကို ဖျက်ရန်',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 30,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(
                    width: Dimensions.height15,
                  ),
                  Text(
                    'တပ်ဆင်ခြင်း',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //backgroundColor: Colors.blueGrey.withOpacity(0.7),
      appBar: AppBar(
        iconTheme: context.theme.primaryIconTheme
            .copyWith(color: Get.isDarkMode ? Colors.white : Colors.black),
        backgroundColor: context.theme.colorScheme.background,
        titleSpacing: 1.5,
        title: Text(
          'Note ',
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => showSearch(
                  context: context,
                  delegate: SearchPage(
                    onQueryUpdate: print,
                    items: notes,
                    searchLabel: 'မှတ်စု ယှာဖွယ်ရန် ...',
                    suggestion: const Center(
                      child: Text(
                          'ကျေးဇူးပြုပြီး မှတ်စု ဂေါင်းစိုင်၊ မှတ်စု စာသား \n(သို့) မှတ်စု နံပါတ်  တခုခု တည့်ပီးပါ။'),
                    ),
                    failure: const Center(
                      child: Text(
                          ' လူကြီးမင်း ယှာလိုရေ မှတ်စုကို ယှာမတွေ့ပါ။\nကျေးဇူးပြု၍ မှတ်စုအသစ်တစ်ခု ပြန်ယှာပီးပါ။ :('),
                    ),
                    filter: (notes) => [
                      notes.title,
                      notes.message,
                      notes.id.toString(),
                    ],
                    builder: (notes) => Card(
                      child: ListTile(
                        title: Text(notes.title),
                        subtitle: Text(
                          notes.message,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: OutlinedButton(
                          onPressed: () {
                            Get.to(const NoteDetailScreen(), arguments: notes);
                          },
                          child: Text('${notes.id} '),
                        ),
                        trailing: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "ဒေမှတ်စုကို ပြန်၍ ပြုပြင်ချင်ပါသလား?\nပြုပြင်လိုပါက ပြုပြင်မည် ကို နှိပ်ပါ။\n(သို့) ဒေမှတ်စုကို ဖျက်လိုပါသလား?\nဖျက်လိုပါက ဖျက်ဖို့ ကို နှိပ်ပါ။"),
                                      content: const Text(
                                          "အထက်က လုပ်ဆောင်ချက်တိမှ တခုကိုလေ့ မလုပ်ချင်ပါက ပြန်လည် မှတ်စု အသစ်ယှာရန် မလုပ်ပါ ကို နှိပ်ပါ။"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Get.to(UpdateScreen(),
                                                  arguments: notes);
                                            },
                                            child: const Text("ပြုပြင်ဖို့")),
                                        TextButton(
                                            onPressed: () {
                                              noteDao.deleteNote(notes);
                                              Get.to(Home(noteDao));
                                            },
                                            child: const Text("ဖျက်ဖို့")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("မလုပ်ပါ")),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(Icons.more_horiz)),
                      ),
                    ),
                  ),
                ),
                child: const Icon(Icons.search),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {
                ThemeService().switchTheme();
                notifyHelper.displayNotification(
                  title: "Theme Changed",
                  body: Get.isDarkMode
                      ? "Activated Light Theme"
                      : "Activated  Dark Theme",
                );
                //notifyHelper.scheduledNotification();
              },
              child: Icon(
                Get.isDarkMode
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round,
                size: 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          )
        ],
      ),

      body: Column(
        
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: noteList(),
          ),
        ],
      ),
    );
  }

  Widget noteList() {
    return StreamBuilder<List<Note>>(
      stream: noteDao.getAllNotes(),
      builder: (_, data) {
        if (data.hasData) {
          notes = data.data!;

          return ListView.builder(
            
           
            itemCount: data.data!.length,
            itemBuilder: (context, position) {
              return Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Card(
                  elevation: 8.0,
                  shadowColor: Colors.black,
                  child: ListTile(
                    title: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      data.data![position].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      data.data![position].message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    trailing: SizedBox(
                      width: Dimensions.listViewTextContainer,
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                Get.to(UpdateScreen(),
                                    arguments: data.data![position]);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "ဒေမှတ်စုကိုဖျက်ရန် သီယှာပါသလား? သီယှာပါက ဖျက် မည် ကို နှိပ်ပီးပါ။ "),
                                        content: const Text(
                                            "မဖျက်ချင်ပါက မလုပ်ပါ ကို နှိပ်ပီးပါ။"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                noteDao.deleteNote(
                                                    data.data![position]);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("ဖျက် မည်")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("မလုပ်ပါ")),
                                        ],
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    minLeadingWidth: 5,
                    leading: IconButton(
                      onPressed: () {
                        Get.to(const NoteDetailScreen(),
                            arguments: data.data![position]);
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (data.hasError) {
          return const Text(
              'လူကြီးမင်းမှာ အသုံးပြုမှု တခုခု မှားယွင်းနိန်ပါရေ။ အပလီကေးရှန်းကို ပြန်လည် စတင်ပီးပါ။');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void _deleteAllNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (notes.isEmpty) {
          return AlertDialog(
            title: const Text("ဖျက်ရန် မှတ်စု မဟိပါ။"),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("back"))
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("သင့်မှတ်စု အားလုံးကို ဖျက်ရန် သီယှာပါသလား?"),
            content: const Text(
                'သီယှာပါက အားလုံးဖျက် မည် ကို နှိပ်ပါ။ မသီယှာပါက မလုပ်ပါ ကို နှိပ်ပီးပါ။'),
            actions: [
              OutlinedButton(
                onPressed: () {
                  noteDao.deleteAllNote(notes);
                  Get.back();
                },
                child: const Text(
                  "အားလုံးကို ဖျက် မည်",
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "မလုပ်ပါ",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
