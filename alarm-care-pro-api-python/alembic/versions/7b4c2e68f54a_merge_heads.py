"""merge_heads

Revision ID: 7b4c2e68f54a
Revises: 802c35f98fb1, ec4880343a4d
Create Date: 2025-08-15 14:17:08.880134

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '7b4c2e68f54a'
down_revision: Union[str, None] = ('802c35f98fb1', 'ec4880343a4d')
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
