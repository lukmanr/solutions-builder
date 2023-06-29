"""
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""
"""
Data model for Task. See https://octabyte.io/FireO/ for details.
"""

import os

from fireo.models import Model
from fireo.fields import IDField, TextField, DateTime, BooleanField, Field
from fireo.queries.errors import ReferenceDocNotExist
from datetime import datetime

# GCP project_id from system's environment variable.
PROJECT_ID = os.environ.get("PROJECT_ID", "")

# Database prefix for integration and e2e test purpose.
DATABASE_PREFIX = os.getenv("DATABASE_PREFIX", "")


# Firebase data model in "{{data_model_plural}}" collection.
class Task(Model):
  """Task ORM class"""

  class Meta:
    ignore_none_field = False
    collection_name = DATABASE_PREFIX + "{{data_model_plural}}"

  id = IDField()
  title = TextField()
  description = TextField()
  stage = TextField()
  status = TextField()
  complete = BooleanField()
  created_at = DateTime()
  modified_at = DateTime()

  # Arbitrary data in JSON format.
  data = Field()

  @classmethod
  def find_by_id(cls, id):
    try:
      task = Task.collection.get(id)
    except ReferenceDocNotExist:
      return None

    return task
