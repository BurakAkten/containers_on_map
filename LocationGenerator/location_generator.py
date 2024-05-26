import json
import random
from tokenize import String
from datetime import datetime, timedelta


def generate_random_date():
    start_date = datetime(2024, 6, 1)
    end_date = datetime(2100, 12, 31)
    
    delta = end_date - start_date
    int_delta = delta.days
    
    random_day = random.randrange(int_delta)
    
    random_date = start_date + timedelta(days=random_day)
    
    return random_date

# Istanbul location information
# min_lat, max_lat = 40.85, 41.20
# min_lon, max_lon = 28.60, 29.40

#umraniye location information
min_lat, max_lat = 40.98, 41.03
min_lon, max_lon = 29.06, 29.21

# Random 1000 container creation part
locations = []
for i in range(1000):
    id = 10000 + i
    next_collection = generate_random_date()
    lat = random.uniform(min_lat, max_lat)
    lon = random.uniform(min_lon, max_lon)
    locations.append({"occupancyRate":random.uniform(0,100),"temperature":random.uniform(0,100),"sensorId":random.randint(1000,10000), "latitude": lat, "longitude": lon, "id": id, "fullnessRate":random.randint(0,100), "nextCollectionDate": next_collection.strftime('%m.%d.%Y')})

containers = {"containers": locations}

# Create Json file
with open("containers_in_istanbul_short.json", "w") as f:
    json.dump(containers, f, indent=4)







