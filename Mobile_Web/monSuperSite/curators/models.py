# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.db import models

# Create your models here.

from django.contrib.auth.models import User
from django.core.validators import MinValueValidator, MaxValueValidator

class Curator(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.TextField(max_length=500, blank=True)
    score = models.IntegerField(default=0, 
                                validators=[MinValueValidator(0),
                                            MaxValueValidator(5)])
    birth_date = models.DateField(null=True, blank=True)

