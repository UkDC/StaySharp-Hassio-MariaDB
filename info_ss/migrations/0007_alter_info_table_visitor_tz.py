# Generated by Django 4.0.10 on 2024-10-03 04:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('info_ss', '0006_alter_info_table_visitor_ip_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='info_table',
            name='visitor_tz',
            field=models.CharField(default='', max_length=20),
        ),
    ]
