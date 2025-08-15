"""create_infusion_pump_ventilator_monitor_history_tables

Revision ID: ec4880343a4d
Revises: 
Create Date: 2025-08-15 14:06:38.985000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import TIMESTAMP


# revision identifiers, used by Alembic.
revision: str = 'ec4880343a4d'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create infusion_pump_history table
    op.create_table(
        'infusion_pump_history',
        sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
        sa.Column('pump_serial_number', sa.String(255), nullable=False),
        sa.Column('state', sa.Boolean, nullable=False),
        sa.Column('message', sa.String(255), nullable=False),
        sa.Column('updated_at', TIMESTAMP(timezone=True), nullable=False),
    )
    
    # Create index on pump_serial_number and updated_at
    op.create_index(
        'idx_pump_serial_time',
        'infusion_pump_history',
        ['pump_serial_number', 'updated_at']
    )
    
    # Create ventilator_history table
    op.create_table(
        'ventilator_history',
        sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
        sa.Column('variable_name', sa.String(255), nullable=False),
        sa.Column('variable_value', sa.String(255), nullable=False),
        sa.Column('unit', sa.String(50), nullable=False),
        sa.Column('updated_at', TIMESTAMP(timezone=True), nullable=False),
    )
    
    # Create monitor_history table
    op.create_table(
        'monitor_history',
        sa.Column('id', sa.Integer, primary_key=True, autoincrement=True),
        sa.Column('variable_name', sa.String(255), nullable=False),
        sa.Column('variable_value', sa.String(255), nullable=False),
        sa.Column('unit', sa.String(50), nullable=False),
        sa.Column('updated_at', TIMESTAMP(timezone=True), nullable=False),
    )


def downgrade() -> None:
    # Drop tables in reverse order to handle dependencies
    op.drop_table('monitor_history')
    op.drop_table('ventilator_history')
    op.drop_index('idx_pump_serial_time', table_name='infusion_pump_history')
    op.drop_table('infusion_pump_history')
