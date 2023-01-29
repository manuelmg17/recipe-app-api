"""
Django admin customization.
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as _

from core import models


class UserAdmin(BaseUserAdmin):
    """Define the admin pages for users."""
    # Orders by id
    ordering = ['id']
    # Only shows email and name
    list_display = ['email', 'name']

    # Here we specify the fields that will show on the edit user page
    # only using values that we created in our custom user model.
    # This will override the default one.
    fieldsets = (
        # None is for the title
        (None, {'fields': ('email', 'password')}),
        (_('Personal Info'), {'fields': ('name',)}),
        (
            _('Permissions'),
            {
                'fields': (
                    'is_active',
                    'is_staff',
                    'is_superuser',
                )
            }
        ),
        (
            _('Important dates'),
            {
                'fields': (
                    'last_login',
                )
            }
        )
    )
    # We made the last login field to be only readable
    readonly_fields = ['last_login']
    # This one is for the 'Add a user' page fieldset
    add_fieldsets = (
        (None, {
            # Classes is just for some indentation/style
            'classes': ('wide',),
            'fields': (
                'email',
                'password1',
                'password2',
                'name',
                'is_active',
                'is_staff',
                'is_superuser',
            )
        }),
    )


admin.site.register(models.User, UserAdmin)
