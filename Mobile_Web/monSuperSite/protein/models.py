# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models

# Create your models here.

class Protein(models.Model):
    name = models.CharField(max_length=255)
    description = models.CharField(max_length=1000)
    gene = models.CharField(max_length=100,default='NOGENENAME')
    mw = models.PositiveIntegerField(blank=True,default=0)

    def __unicode__(self):
        return u'%s' % self.name
