# Deployment Order

## 1. spokes
- Deploy Spokes (ggf. DNS Spoke)

## 2. connectivity
- Deploy vWAN Hub & Firewall
- Deploy DNS Zones & Link them to Spokes/ or DNS Spoke
- Peer spokes to vWAN hub

## 3. core
- Create Management Group Structure
- Create Custom Policies
- Create Custom Roles

## 4. management
- Create Central Log Analytics

## 5. firewall-management
- Deploy Firewall Rules