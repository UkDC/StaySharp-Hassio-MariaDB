# Generated by Django 4.1 on 2022-08-31 13:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("stay_sharp", "0009_alter_all_knifes_brend_alter_all_knifes_series_and_more"),
    ]

    operations = [
        migrations.AlterField(
            model_name="all_knifes",
            name="brand",
            field=models.CharField(blank=True, default="", max_length=20, null=True),
        ),
        migrations.AlterField(
            model_name="all_knifes",
            name="series",
            field=models.CharField(blank=True, default="", max_length=20, null=True),
        ),
        migrations.AlterField(
            model_name="all_knifes",
            name="steel",
            field=models.CharField(blank=True, default="", max_length=15, null=True),
        ),
    ]
