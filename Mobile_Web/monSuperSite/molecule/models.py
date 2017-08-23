# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models

# Create your models here.

from protein.views import Protein

class Molecule(models.Model):
    pdb_code=models.CharField(max_length=4,blank=True)
    pdb_chain=models.CharField(max_length=1,blank=True)
    description=models.CharField(max_length=255,blank=True)
    prot=models.ManyToManyField(Protein)

    def __unicode__(self):
        return u'%s_%s' % (self.pdb_code,self.pdb_chain)
