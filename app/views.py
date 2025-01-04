
# Create your views here.
from django.shortcuts import render
from django.http import HttpResponse
from .forms import ContactForm
from django.core.mail import send_mail

# views.py
def home(request):
    return render(request, 'home.html')

def about(request):
    return render(request, 'about.html')

def projects(request):
    return render(request, 'projects.html')

def contact(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            send_mail(
                f"Message from {form.cleaned_data['name']}",
                form.cleaned_data['message'],
                form.cleaned_data['email'],
                ['your_email@example.com'],
            )
            return render(request, 'contact.html', {'form': form, 'success': True})
    else:
        form = ContactForm()
    return render(request, 'contact.html', {'form': form})