import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_event.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_state.dart';

class QueryPage extends StatefulWidget {
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = ['General', 'Technical Support', 'Billing', 'Installation', 'Maintenance'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<QueryBloc, QueryBlocState>(
        listener: (context, state) {
          if (state is QuerySubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Query submitted successfully!'), backgroundColor: Colors.green),
            );
            _clearForm();
          } else if (state is QueryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submit Query', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Have questions or need support? Send us your query and we\'ll get back to you.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 24),
              
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
                      items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                    SizedBox(height: 20),
                    
                    Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.title), hintText: 'Brief title for your query'),
                      validator: (value) => value?.isEmpty == true ? 'Please enter a title' : null,
                    ),
                    SizedBox(height: 20),
                    
                    Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 6,
                      decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Describe your query in detail...'),
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Please enter a description';
                        if (value!.length < 10) return 'Description must be at least 10 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    
                    BlocBuilder<QueryBloc, QueryBlocState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is QuerySubmitting ? null : _submitQuery,
                            child: state is QuerySubmitting
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Submit Query', style: TextStyle(fontSize: 16)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitQuery() {
    if (_formKey.currentState!.validate()) {
      context.read<QueryBloc>().add(SubmitQuery(_selectedCategory, _titleController.text.trim(), _descriptionController.text.trim()));
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() => _selectedCategory = 'General');
  }
}