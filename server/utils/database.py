import os
from models import init_db as models_init_db

def init_db(app, connection_string=None, testing=False):
    """
    Initializes the database with the given Flask app and connection string.
    If no connection string is provided, a default SQLite connection string is used.
    
    Args:
        app: The Flask application instance
        connection_string: Optional database connection string
        testing: If True, allows reinitialization for testing
    """
    if connection_string is None:
        connection_string = __get_connection_string()
    app.config['SQLALCHEMY_DATABASE_URI'] = connection_string
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    models_init_db(app, testing=testing)

def __get_connection_string():
    """
    Returns the connection string for the database.
    """
    # Get the server directory
    server_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    # Go up one level to project root, then into data folder
    project_root = os.path.dirname(server_dir)
    data_dir = os.path.join(project_root, "data")
    
    # Create the data directory if it doesn't exist
    os.makedirs(data_dir, exist_ok=True)
    
    return f'sqlite:///{os.path.join(data_dir, "tailspin-toys.db")}'