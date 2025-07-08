# 🌐 Unsplash API Setup Guide

## 📝 **Step 1: Get Unsplash API Key**

1. **Go to**: https://unsplash.com/developers
2. **Sign up/Login** with your account
3. **Click "New Application"**
4. **Fill the form**:
   - **Application name**: `Nail Store`
   - **Description**: `Flutter nail art inspiration app`
   - **Website**: `https://yourapp.com` (or any placeholder)
5. **Accept terms** and submit
6. **Copy your Access Key** (starts with `Client-ID`)

## 🔧 **Step 2: Add API Key to App**

Open `lib/services/unsplash_service.dart` and replace:

```dart
static const String _accessKey = 'YOUR_ACCESS_KEY_HERE';
```

With your actual key:

```dart
static const String _accessKey = 'your-actual-access-key-here';
```

## 🚀 **Step 3: Test the Integration**

### **Run the app:**
```bash
flutter run
```

### **Expected Results:**
- App will load **mock data first** (fast)
- Then load **100 real nail art images** from Unsplash
- Categories will have real photos
- Search will work with real content

## 📊 **API Limits & Info**

### **Free Tier:**
- ✅ **50 requests/hour**
- ✅ **Unlimited downloads**
- ✅ **Commercial use allowed**

### **Categories Available:**
- French manicure
- Gel nails
- Acrylic nails
- Glitter nails
- Matte nails
- Ombre nails
- Stiletto nails
- Short nails

## 🔄 **How It Works**

### **App Startup:**
1. Loads mock data (10 designs)
2. Fetches 100 real images from Unsplash
3. Mixes both for rich content

### **Fallback System:**
- If API fails → Uses mock data only
- If specific category fails → Skips silently
- No crashes, always works

## 🎯 **Next Steps**

### **Immediate:**
1. Get API key (5 minutes)
2. Test with real images
3. Verify different categories

### **Future:**
1. Add **Pexels API** for more images
2. Add **user upload system**
3. Add **AI categorization**

## 🔍 **Troubleshooting**

### **No images loading?**
- Check API key is correct
- Check internet connection
- Look at Flutter console for errors

### **Rate limit exceeded?**
- Wait 1 hour (free tier: 50/hour)
- Or upgrade to paid plan

### **API key not working?**
- Verify it starts with your actual key
- Check Unsplash dashboard for app status

---

**🎉 Ready to test? Add your API key and run the app!** 