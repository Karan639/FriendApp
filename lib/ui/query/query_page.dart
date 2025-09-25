import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_event.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_state.dart';

class QueryPage extends StatefulWidget {
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load queries when page initializes
    context.read<QueryBloc>().add(LoadQueries());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Queries'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Submit Query'),
            Tab(text: 'My Queries'),
          ],
        ),
      ),
      body: BlocListener<QueryBloc, QueryBlocState>(
        listener: (context, state) {
          if (state is QuerySubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Query submitted successfully!'), backgroundColor: Colors.green),
            );
            _clearForm();
            // Reload queries after submission
            context.read<QueryBloc>().add(LoadQueries());
          } else if (state is QueryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSubmitQueryTab(),
            _buildQueriesListTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitQueryTab() {
    return SingleChildScrollView(
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
                Text('Subject', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), 
                    prefixIcon: Icon(Icons.title), 
                    hintText: 'Brief subject for your query'
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Please enter a subject' : null,
                ),
                SizedBox(height: 20),
                
                Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), 
                    hintText: 'Describe your query in detail...'
                  ),
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
    );
  }

  Widget _buildQueriesListTab() {
    return Column(
      children: [
        // Status filter
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Filter: ', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: 'OPEN',
                items: ['OPEN', 'CLOSED', 'IN_PROGRESS', 'RESOLVED']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<QueryBloc>().add(LoadQueries(status: value));
                  }
                },
              ),
            ],
          ),
        ),
        // Queries list
        Expanded(
          child: BlocBuilder<QueryBloc, QueryBlocState>(
            builder: (context, state) {
              if (state is QueryLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is QueryLoaded) {
                if (state.queries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No queries found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: state.queries.length,
                  itemBuilder: (context, index) {
                    final query = state.queries[index];
                    return Card(
                      child: ListTile(
                        title: Text(query.subject, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(query.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 4),
                            Chip(
                              label: Text(query.status, style: TextStyle(fontSize: 12)),
                              backgroundColor: _getStatusColor(query.status),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Text('#${query.id}', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  },
                );
              } else if (state is QueryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}'),
                      ElevatedButton(
                        onPressed: () => context.read<QueryBloc>().add(LoadQueries()),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return Center(child: Text('No queries loaded'));
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'OPEN':
        return Colors.orange.shade100;
      case 'IN_PROGRESS':
        return Colors.blue.shade100;
      case 'RESOLVED':
        return Colors.green.shade100;
      case 'CLOSED':
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _submitQuery() {
    if (_formKey.currentState!.validate()) {
      context.read<QueryBloc>().add(
        SubmitQuery(_subjectController.text.trim(), _descriptionController.text.trim()),
      );
    }
  }

  void _clearForm() {
    _subjectController.clear();
    _descriptionController.clear();
  }
}