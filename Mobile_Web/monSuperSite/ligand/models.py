# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models

# Create your models here.

from protein.models import Protein

class Ligand(models.Model):
    pubchem_id=models.PositiveIntegerField(blank=True)
    common_name=models.CharField(max_length=255)
    chemical_name=models.CharField(max_length=255)
    p=models.ForeignKey(Protein)
    
    def __unicode__(self):
        return u'%s' % self.common_name

