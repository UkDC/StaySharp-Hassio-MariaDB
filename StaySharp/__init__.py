# This will make sure the app is always imported when
# Django starts so that shared_task will use this app.
from __future__ import absolute_import
from .celery_tasks import app as celery_app

__all__ = ('celery_app',)

import pymysql
pymysql.install_as_MySQLdb()
