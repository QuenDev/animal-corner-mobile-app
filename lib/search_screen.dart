import 'package:flutter/material.dart';
import 'package:flutter_application_2/pet_profile.dart';
import 'package:flutter_application_2/schedule_screen.dart';
import 'package:flutter_application_2/history_screen.dart';
import 'package:flutter_application_2/dashboard_screen.dart';
import 'package:flutter_application_2/notif_screen.dart';
import 'package:flutter_application_2/setting_screen.dart';
import 'package:flutter_application_2/back_button.dart';


class SearchScreen extends StatefulWidget {
  final int currentIndex;

  const SearchScreen({super.key, required this.currentIndex});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late int _currentPage;
  List<Map<String, String>> petCareItems = [];
  List<Map<String, String>> displayedItems = [];
  String _searchText = '';
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
    _loadPetCareItems(); // Load dynamic content
    _filterInitialItems(); // Display only initial items
  }

 void _loadPetCareItems() {
    setState(() {
      petCareItems = [
        // Grooming tips
        {
          'title': 'Grooming Tips for Dogs',
          'briefDescription': 'Regular grooming keeps your dog’s coat shiny.',
          'description':
              'Keeping your dog’s coat shiny and healthy requires regular grooming. '
              'Brush your dog’s fur daily to avoid matting, and bathe them at least once a month. '
              'Ensure you are using a shampoo designed for dogs, as human shampoos can dry out their skin.',
          'category': 'Grooming'
        },
        {
          'title': 'Cat Grooming Techniques',
          'briefDescription': 'Long-haired cats may need extra grooming help.',
          'description':
              'Cats are generally self-groomers, but long-haired cats may need a bit of help. '
              'Brush your cat’s coat every couple of days to prevent tangles. Trimming their nails regularly and wiping their eyes and ears ensures complete grooming care.',
          'category': 'Grooming'
        },
        {
          'title': 'Essential Grooming Tools',
          'briefDescription': 'Every pet owner should have essential grooming tools.',
          'description':
              'Every pet owner should have a set of essential grooming tools such as brushes, nail clippers, and pet-safe shampoos. '
              'The right tools make grooming easier and more comfortable for your pet. '
              'Learn how to select the right brush for your pet’s coat type and get comfortable with nail trimming techniques.',
          'category': 'Grooming'
        },
        {
          'title': 'Grooming for Long-haired Dogs',
          'briefDescription': 'Long-haired dogs require daily brushing.',
          'description':
              'Long-haired dogs require extra care when it comes to grooming. '
              'Make sure you brush their fur daily to avoid mats and tangles. Use detangling sprays if needed. Regular trims, especially around their paws and belly, help keep their coat manageable.',
          'category': 'Grooming'
        },
        {
          'title': 'Bathing Your Dog at Home',
          'briefDescription': 'Bathing your dog at home can be enjoyable.',
          'description':
              'Bathing your dog at home can be a fun and rewarding experience. Use lukewarm water and a pet-safe shampoo to cleanse their fur. '
              'Be sure to rinse thoroughly, and avoid getting soap in their eyes or ears. Dry them with a towel or a pet dryer to avoid dampness.',
          'category': 'Grooming'
        },
        {
          'title': 'Brushing Your Cat',
          'briefDescription': 'Regular brushing minimizes shedding and hairballs.',
          'description':
              'Regular brushing is important for cats, especially those with long fur. '
              'Brushing not only helps keep their coat healthy but also minimizes shedding and hairballs. Make it a soothing routine for your cat by using gentle strokes and a soft brush.',
          'category': 'Grooming'
        },
        // Nutrition tips
        {
          'title': 'Healthy Diet for Cats',
          'briefDescription': 'A balanced diet is essential for your cat’s health.',
          'description':
              'Providing your cat with a balanced and nutritious diet is essential for their overall health. '
              'Ensure their diet includes a mix of high-quality proteins, fats, and essential vitamins. '
              'Avoid overfeeding, and provide fresh water at all times to keep them hydrated.',
          'category': 'Nutrition'
        },
        {
          'title': 'Dog Nutrition for Weight Loss',
          'briefDescription': 'Adjust your dog’s diet for healthy weight loss.',
          'description':
              'If your dog is overweight, you may need to adjust their diet. Focus on lean protein sources and incorporate fiber-rich vegetables like carrots and green beans. '
              'Reduce treats and increase physical activity to support weight loss in a healthy way.',
          'category': 'Nutrition'
        },
        {
          'title': 'Best Foods for Puppies',
          'briefDescription': 'Puppies require a specific diet for growth.',
          'description':
              'Puppies have specific nutritional needs as they grow. A diet rich in protein, healthy fats, and essential nutrients like DHA will support brain development and strong bones. '
              'Always choose a puppy-specific food to ensure they’re getting the right balance of nutrients.',
          'category': 'Nutrition'
        },
        {
          'title': 'Avoiding Harmful Foods for Pets',
          'briefDescription': 'Certain human foods can be toxic to pets.',
          'description':
              'Certain human foods can be toxic to pets. Foods such as chocolate, grapes, onions, and garlic should be kept away from them at all times. '
              'Be cautious about table scraps and inform your family and guests of what foods are off-limits for your pet’s safety.',
          'category': 'Nutrition'
        },
        {
          'title': 'Balancing Meals for Active Dogs',
          'briefDescription': 'Active dogs need a balanced diet for energy.',
          'description':
              'Active dogs need a diet that fuels their energy levels. Feed them a balanced meal that includes high-quality proteins and healthy fats. '
              'Carbohydrates are also important for maintaining their energy during physical activities like running and playing.',
          'category': 'Nutrition'
        },
        {
          'title': 'Hydration Tips for Cats',
          'briefDescription': 'Encourage your cat to drink more water.',
          'description':
              'Cats can be finicky about water. Encourage them to drink more by providing fresh water in a clean bowl daily. '
              'You can also introduce a water fountain, which can intrigue them to drink more frequently. Hydration is crucial for their kidney health.',
          'category': 'Nutrition'
        },
        // Training tips
        {
          'title': 'Training Your Puppy',
          'briefDescription': 'Start training your puppy with positive reinforcement.',
          'description':
              'Start training your puppy early to establish good habits. Basic commands such as “sit,” “stay,” and “come” can be taught with positive reinforcement. '
              'Use treats and praise to encourage them, and be consistent with your training schedule to see faster results.',
          'category': 'Training'
        },
        {
          'title': 'Advanced Dog Training Techniques',
          'briefDescription': 'Move to advanced training after basic commands.',
          'description':
              'Once your dog has mastered basic commands, you can move on to more advanced training such as “roll over,” “fetch,” or even agility exercises. '
              'Patience is key, as some dogs take longer to learn complex tasks, but with consistency and reward-based training, success is achievable.',
          'category': 'Training'
        },
        {
          'title': 'Crate Training Your Dog',
          'briefDescription': 'Crate training helps with housebreaking and safety.',
          'description':
              'Crate training is an effective way to manage your dog’s behavior, especially for housebreaking and keeping them safe when unsupervised. '
              'Make the crate a positive space with comfortable bedding and toys, and gradually increase the time they spend inside.',
          'category': 'Training'
        },
        {
          'title': 'Leash Training Basics',
          'briefDescription': 'Leash training can be challenging but rewarding.',
          'description':
              'Leash training can be challenging for some dogs. Start by letting them wear the leash around the house so they get used to it. '
              'Then take short, controlled walks, rewarding them for walking calmly by your side. Patience and practice make perfect!',
          'category': 'Training'
        },
        {
          'title': 'Socializing Your Pet',
          'briefDescription': 'Socializing prevents future behavioral problems.',
          'description':
              'Socializing your pet is critical to preventing behavioral problems in the future. '
              'Expose your pet to new environments, people, and other animals in a controlled, positive way to help them develop confidence and reduce anxiety in social situations.',
          'category': 'Training'
        },
        {
          'title': 'Clicker Training for Dogs',
          'briefDescription': 'Clicker training helps dogs learn faster.',
          'description':
              'Clicker training is an effective way to communicate with your dog. The click sound marks the exact moment your dog performs a desired behavior, followed by a treat. '
              'This method helps dogs understand what behavior they are being rewarded for, leading to faster learning.',
          'category': 'Training'
        },
        // Health tips
        {
          'title': 'Preventing Pet Obesity',
          'briefDescription': 'Keep your pet healthy by preventing obesity.',
          'description':
              'Preventing obesity in pets is vital for their health. Monitor their food intake and exercise regularly. '
              'Obesity can lead to serious health issues like diabetes and joint problems, so be proactive in managing their weight through proper diet and activity levels.',
          'category': 'Health'
        },
        {
          'title': 'Regular Vet Check-ups',
          'briefDescription': 'Regular vet visits are crucial for pet health.',
          'description':
              'Regular veterinary check-ups are crucial for maintaining your pet’s health. These visits allow for early detection of potential health issues and ensure vaccinations are up-to-date. '
              'Your vet can provide guidance on nutrition and dental care as well.',
          'category': 'Health'
        },
        {
          'title': 'Dental Care for Pets',
          'briefDescription': 'Dental health is essential for overall wellness.',
          'description':
              'Dental care is often overlooked but is essential for overall wellness in pets. Brush their teeth regularly and consider dental treats to help reduce plaque buildup. '
              'Regular vet cleanings may also be necessary to keep their teeth healthy.',
          'category': 'Health'
        },
        {
          'title': 'Recognizing Signs of Illness',
          'briefDescription': 'Know the signs of illness to keep pets healthy.',
          'description':
              'Recognizing signs of illness in pets can help you take prompt action. Watch for changes in behavior, appetite, or energy levels, as these can indicate a health issue. '
              'If you notice anything unusual, consult your vet for advice.',
          'category': 'Health'
        },
        {
          'title': 'Protecting Pets from Parasites',
          'briefDescription': 'Regular parasite prevention is crucial.',
          'description':
              'Protecting your pet from parasites such as fleas and ticks is crucial for their health. Use veterinarian-approved preventive treatments and check your pet regularly for signs of parasites, especially during warm weather.',
          'category': 'Health'
        },
        {
          'title': 'First Aid for Pets',
          'briefDescription': 'Know basic first aid for pet emergencies.',
          'description':
              'Knowing basic first aid for pets can be lifesaving. Familiarize yourself with common emergency procedures, such as how to perform CPR on pets or how to treat cuts and wounds. '
              'Always have a pet first aid kit available and consult your vet for advice on emergency protocols.',
          'category': 'Health'
        },
      ];
    });
  }

  void _filterInitialItems() {
  // Display only one tip per category initially
  Set<String> categoriesShown = {};
  setState(() {
    displayedItems = petCareItems.where((item) {
      if (categoriesShown.contains(item['category'])) {
        return false;
      } else {
        categoriesShown.add(item['category']!);
        return true;
      }
    }).toList();
  });
}


  void _filterItems() {
  setState(() {
    if (_searchText.isEmpty && _selectedCategory.isEmpty) {
      // No search and no category filter, display one tip per category
      _filterInitialItems();
    } else if (_searchText.isNotEmpty && _selectedCategory.isEmpty) {
      // Search text entered, but no category filter
      displayedItems = petCareItems.where((item) {
        return item['title']!.toLowerCase().contains(_searchText.toLowerCase()) ||
               item['description']!.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    } else if (_searchText.isEmpty && _selectedCategory.isNotEmpty) {
      // No search text, but category filter selected
      displayedItems = petCareItems.where((item) {
        return item['category'] == _selectedCategory;
      }).toList();
    } else {
      // Both search text and category filter selected
      displayedItems = petCareItems.where((item) {
        final matchesSearch = item['title']!.toLowerCase().contains(_searchText.toLowerCase()) ||
                              item['description']!.toLowerCase().contains(_searchText.toLowerCase());
        final matchesCategory = item['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    }
  });
}

void _showPetCareDialog(Map<String, String> item) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['title'] ?? 'Untitled',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                child: Text(
                  item['description'] ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    height: 1.6,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
     return BackButtonHandler(
    child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  iconSize: 30.0,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NotificationScreen(currentIndex: 0)),
                    );
                  },
                ),
                const Center(
                  child: Text(
                    'Animal Corner',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  iconSize: 30.0,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SettingsScreen(currentIndex: 4)),
                    );
                  },
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilters(),
          Expanded(
            child: _buildPetCareGrid(),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    ),
     );
  }

  Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    child: TextField(
      onChanged: (text) {
        _searchText = text;
        _filterItems();
      },
      decoration: InputDecoration(
        hintText: 'Search pet care tips...',
        filled: true,
        fillColor: Colors.green[50],
        prefixIcon: const Icon(Icons.search, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );
}

 Widget _buildCategoryFilters() {
  List<String> categories = ['Grooming', 'Training', 'Health', 'Nutrition'];

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    height: 45,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ChoiceChip(
            label: Text(
              categories[index],
              style: const TextStyle(color: Colors.white),
            ),
            selected: _selectedCategory == categories[index],
            onSelected: (selected) {
              setState(() {
                _selectedCategory = selected ? categories[index] : '';
                _filterItems();
              });
            },
            backgroundColor: Colors.green.shade700,
            selectedColor: Colors.green.shade700,
            elevation: 3,
          ),
        );
      },
    ),
  );
}

 Widget _buildPetCareGrid() {
  return GridView.builder(
    padding: const EdgeInsets.all(10.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      childAspectRatio: 2 / 2.5, // Keeps the original card size consistent
    ),
    itemCount: displayedItems.length,
    itemBuilder: (context, index) {
      return _buildPetCareCard(displayedItems[index]);
    },
  );
}

Widget _buildPetCareCard(Map<String, String> item) {
  return GestureDetector(
    onTap: () {
      _showPetCareDialog(item);
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.green[50],
      elevation: 6,
      shadowColor: Colors.teal.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['title'] ?? 'Untitled',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  item['briefDescription'] ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black87,
                    height: 1.5,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, color: Colors.green),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'Tap for details',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.green[700],
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCustomBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
         colors: [Colors.green.shade400, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
        unselectedLabelStyle:
            const TextStyle(fontSize: 11, fontFamily: 'Montserrat'),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        onTap: (index) {
          if (index != _currentPage) {
            setState(() {
              _currentPage = index;
            });

            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DashboardScreen(currentIndex: index)),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchScreen(currentIndex: index)),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScheduleScreen(currentIndex: index)),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HistoryScreen(currentIndex: index)),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(currentIndex: index)),
                );
                break;
              default:
                break;
            }
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets, size: 24),
            label: 'Petcare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 24),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 24),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
