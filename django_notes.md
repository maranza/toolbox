# Installation
`sudo pip3 install Django==1.8`  
(Latest release is 1.11.1, but the open classroom mooc is in 1.8.  
Remember to go check the enhancements)  

# Some theory
## Once again : MVC architecture in theory
The **model** is built to access the information stored somewhere. It is a
layer between the code and the database  
The **view** is built to visualize this information and receive action from the
user of the view (eg: a web page)  
The **controller** handles the user's actions and send the result to the *view*  
When a page is called, the controller is the first element to be loaded.  

## Django architecture is MVT
Django handles the controller part by itself and adds the notion of template.
The **template** is an HTML file retrieved by the view and sent to the visitor.  

Ok, so basically, when a user asks for a web page :
* Django picks the right the correct view thanks to the routes rules
* The view retrieves the data from the model and generates the page, thanks to
the HTML template
* The call send the result to the server

Template = Classic HTML file  
Model = Python class : each attributes is a field of the table (named after the class)  
Vue = Python function   

# How to dev : the basics
A web site is a project with several applications.  
An application is a folder with code files (views, model, urls schemes)   

To launch a new *project* :  
`django-admin.py startproject project_name`  
`manage.py` ~ `django-admin.py`  
`urls.py` contains ALL of the website's urls

To start the server :  
`python3.5 manage.py runserver`  

To create a new *application* :
`python3.5 manage.py startapp appname`  
=> this creates a folder at the same level than the "subproject"  
=> models and views are defined here  
=> it has to be added in `settings.py` (in INSTALLED_APPS variable) to be
considered as a project's app  

To find some help with manage.py tool :  
`python3.5 manage.py help`   

## How to : create a view and make it reachable
Reminder : a view is a function defined in `views.py`. It has to be linked to at
least one url. A view has an HTTP request as parameter and sends back an
HTTP response. 
The request **HAS TO BE THE FIRST** parameter of the function, otherwise, it won't work

The url-view association is done in the views.py file, by filling the urlpatterns list.
r'^$' => means : the root of the website
in the list you should add the regex matching the adress and the function to call.

Having a unique urls.py file is not the best choice in term of re-usability of application, so we should add a specific
urls.py file in each app

## How to pass arguments to the view
They have to be retrieved from the url and passed to the functions  
 => so regex in urls.py !  
 To be more flexible, it's useful to specify the name of each parameter  
 in the url pattern list, as they are defined in the depending function.   
 
 Also, it's easy to retrieve GET parameter, as simple as this (in the function obviously)   

## How to send specific response 
Django provides a lot of tools, to redirect the user or raise a 404 page
### A 404 page : 
just use  Http404 from django.http package
Also, when requesting for an object, using getObjectOr404 method is a good practice

### A redirection 
This is more complex, there are many ways to do this 
* `return redirect("https://www.djangoproject.com")` in the view function 
* `return redirect(another_function)` and set an url rule in urls.py 
* `return redirect('app.views.function', parameter=42)`

You should NEVER write a real url in views.py prefer to define it in urls.py

## Let's talk about the template engine  
No HTML code should be mixed with python code, for obvious reasons.  
Template are written in a django specific meta language, which provides
some basic controls such as if/else structure, for loop, etc  
=> They are named "tag"  
This meta language is called __jinja__. 

### How to link a view to a template ? 
Just remember that the view has to handle the query from the user, and 
then send back the generated HTML page to it. 
To call the right template, django provides a specific method __render__
render() takes 3 parameters : 
* the original request
* the HTML template location 
* the dictionnary containing variables to pass to the template 
/!\ The template parent folder should be filled in settings.py, into the 
list TEMPLATES.DIRS. 
also, remember that it is usefull to have 1 `templates`  folder in each app
The `comment` block and this syntax :{# blabla #} allows to write comments 
in the code, which won't be added to the HTML generated code. 

## The power of models
This is the part which make the webapp dynamic. So a bit useful :) 
A model is written like a python class and represents a database table. 
Each attribute is a table field. 
All of an app model is written in the app `models.py` file, so let's 
don't mix model between apps. 
/!\ Instead of using syncdb you should use makemigrations and then migrate.


## The administration module, a powerful tool !
TBD

## Forms 
They are declared like a model (in a class), but they don't need to have a specific file. 
We do it here, for a better visibility. 
Some fields type come with specific argument, such as boolean, which 
needs a `required` argument, if not, the form will not be valid until the check box is 
thicked. 
So, to add a form you have to :
- build a class for the form, which inherits from forms.Form class
- add the view method 
- add the new url 
- build the new HTML template

You can add specific validation rules by : 
- Creating a field-specific filter method in the form class and raising a ValidationError (from the forms package)  
Its name has to start with `clean_` and be followed by the name of the field to be checked. 
- Create a unique validation method inherithed from the mother Class: `clean` 
This method can raise several ValidationError, or return the form if it's valid. 

Also you can create form related to a specific model. To do that yu should use the ModelForms class like this :  
``` python 
class ArticleForms(forms.ModelForm):
    class Meta:
        model = Article
        # exclude = ('slug',)
        fields = ('title', 'author', 'slug', 'category', 'content')
```

## Dealing with files
TODO 
## Generic views 
### Display Objects 
Remember that Django's philosophy is DRY : Don't Repeat Yourself.   
That's why generic views have been created.   
We will often have to create a view to display an HTML template, an item list, ...   
Then Django provides ready-to-use views to help us in that.  

#### TemplateView 
Can be created directly in the urls.py or by creating a _**class**_ using the package `django.views.generic`  
```python 
class FAQView(TemplateView):
   template_name = "blog/faq.html"
   ```
or 
`url(r'^faq', TemplateView.as_view(template_name='blog/faq.html'))
`  
#### ListView
Django offers a lot of possibilities of customization when using ListView.  
As for TemplateView, you can define a ListView in urls.py or in views.py. 
If you just want to display the list of an object : use urls.py, but your template has to be named :
`<appname>/<model>_list.html`  
If you want to add some customization, such as pagination, filter and so on, use class in views.py, it will enhance readability. 

```python 
class BlogPostList(ListView):
    model = Post
    context_object_name = "last_posts"
    template_name = "blog/home.html"
    paginate_by = 10
 
    def get_queryset(self):
       return Post.objects.filter(category__id=self.args[0])

```
  
#### DetailView
The aim here is to display only one object from a model.  
The principle and option are quite the same as in ListView.  
The only significative change is the usage of "pk"

### Manipulate objects : CRUD
#### CreateView
Create is used very often in web : post a comment, create an article, ...
We can note that python interprets the views before interpreting the URLs. 
Because of that, reverse url resolution cannot be used as in template, but we can use `reverse_lazy` function for that.
See below an example of using it :
```python
class MiniURLCreate(CreateView):
    model = MiniURL
	template_name = "templates/new_redirect.html"
	form_class = MiniURLForm
	success_url = reverse_lazy(display) # Here display is a name of a view defined in views.py
```
#### UpdateView
The attributes are the same as in `CreateView`. Because of that we can use the same template to create and update. 
If needed, we can create a specific one, especially to avoid updating some fields.
To limit field to update, just add the "fields" attribute in the class : 
`fields = ['pseudo']`
Keep in mind that even if the template is the same, the url is different, as we have to specify a parameter : which object to update. 

We can easily override the get_object method for example to update the object by its code instead of its 'pk' (which is by default). 

#### DeleteView
This type of view displays a confirmation page before deleting the input object. 
Except that, the usage is quite the same as for UpdateView. 


## Go further with models
Django offers a lot of capabilities with models : 
* Complex queries
* Aggregation 
* Inheritance  

### Complex queries using Q 
Q is an object provided by models allows to do complex queries of filters.  
For example, see below to combine 2 filters with an 'OR' clause :  
`Student.objects.filter(Q(average__gt=16) | Q(average__lt=8)`
| Operator  | Usage         |
| --------- |-------------- |
| '|'       | represents OR |
| &, ','    | represent AND |
| ~         | represents NOT|
Q accepts another syntax : `Q(average,10)` is the same as `Q(average=10)` 
This is powerful to apply condition to a bunch of data. 

### Aggregation 
The aggregate method has several functions, such as Avg, Min, Max, Count, ... and returns a dictionary.  
`from django.db.models import Avg, Min, Max, Count`
`Article.objects.aggregate(Avg('rating'))`
returns `{'rating__avg': 4.6}`

`Article.objects.aggregate(Avg('rating'), Count('rating'))`
returns `{'rating__count': 5, 'rating__avg': 4.6}`

Aggregation is also usable with ManyToMany Fields. 
The `annotate` methods provides a way to add the aggregation as an attribute to an object. 

### Inheritance between models
#### Abstract Models
Abstracts models are useful when you have several models using same attributes and methods.
With Django, the abstract model does not have a dedicated table in the RDBMS and obviously we cannot query it.  
To make a model abstract we just need to add the attribute abstract=Meta in the subclass Meta 
```python 
    class Meta:
        abstract = True
```

#### Classic parent models
Parent models are real model, that can be instantiate, but are inherited by others 

#### Proxy models 
A proxy model inherits from all attributes and methods from its parents but no table will be created for it.  
The main interest is that we may want to modify the meta class, or add method to the proxy model without modifying  
the behavior of the parent model. 

#### The ContentType Application 
A content type is a model that describes other models. From a content type you can browse the content of a model.
It provides the capability to build a generic relation between models. 

## Simplifying our templates 
Django offers a lot of tags and filter in templates, but you may need someday to create your own. 
To do that, you have to create a `templatetags` package either in your app folder,  
or in a specific app if your tags / filter can be used in several apps. 

### Filters
Filters are basic python method with a decorator @register.filter from django.templates. 
Example below : 
```python 
from django import template

register = template.Library()


@register.filter(name='completeme')
def add_random_text(text):
	"""Add some text to short article"""
	if len(text) < 55:
		return text + ' another part of text to show that you have write a lot of stuff'
	else:
		return text
```

### Template context processor
Very useful to share variable between templates with an app (`<app_name>/context_processors.py`)  
or with the whole project (`<project_name>/context_processors.py`)
Basically all you have to do is to :
* create your function that return the data to share
    * taking `request` as parameter
    * returning a dictionary with value to share
* declare the template context processor in settings.py
* enjoy ! 

Keep in mind that the view and then the template so don't use the same variable name  . 

### Custom tags
