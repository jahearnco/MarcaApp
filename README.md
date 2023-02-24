# ![Marca Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp">MarcaApp</a>
MARCA is a Management And Resources Coordination Application

<li>AWS based suite implemented for a large scale mail-in balloting production

<li>coordinates communications, reports, analyses, workgroups, operations and resources.

<li>leverages fast DynamoDB-Java workgroup lookup routines.

<li>configurable for most organizations : families, clinics, mid-sized businesses, personal projects. Etc.
<a name="vid" /><br/><br/>

MarcaApp is a limited feature app version of MARCA based on iOS Amplify-Swift libraries
# ![Marca Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://youtu.be/eff2Ofq2ft0">Video</a>
   &nbsp; &nbsp; &nbsp; ![Marca Banner](Assets.xcassets/profile_1.png) &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  ![Marca Banner](Assets.xcassets/groupText.png) &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ![Marca Banner](Assets.xcassets/viewLogs.png)

# ![Marca Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp/Views/CustomViews">Custom Views</a>
   <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp/Views/CustomViews/MarcaButton.swift">MarcaButton</a><br/>
   <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp/Views/CustomViews/MarcaLogView.swift">MarcaLogView</a><br/>
   <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp/Views/CustomViews/MarcaSelect.swift">MarcaSelect</a><br/>
   <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp/Views/CustomViews/MarcaTextField.swift">MarcaTextField</a>
# ![Marca Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp/Ancillary/Auth">Auth</a>
   <a href="https://github.com/jahearnco/MarcaApp/blob/main/MarcaApp/Ancillary/Auth/Cognito.swift">AWS Cognito</a><br/>
   <a href="https://github.com/jahearnco/MarcaApp/blob/main/MarcaApp/Ancillary/Auth/KeyChainProxy.swift">KeyChainProxy</a>
# ![Marca Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://github.com/jahearnco/MarcaApp/blob/main/MarcaApp/Ancillary/Constants/MarcaEnums.swift">Enums</a>
    enum KeychainError: Error
    enum MarcaViewChoice
    enum MarcaProfileTitle:String,CaseIterable
    enum MarcaLoginMenuChoice:String,CaseIterable
    enum MarcaCreateTextMenuChoice:String,CaseIterable
    enum MarcaEditProfilesMenuChoice:String,CaseIterable
    enum MarcaProfileStatusChoice:String,CaseIterable
    enum MarcaLogsViewMenuChoice:String,CaseIterable
    enum MarcaSelectType:String,CaseIterable
# ![Marca Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://github.com/jahearnco/MarcaApp/blob/main/MarcaApp/Ancillary/Models/_M.swift">Model</a>
    @Published var cacheKiller:String
    @Published var isPortraitOrientation:Bool
    @Published var isLoginButtonPressed:Bool
    @Published var headerHeight:CGFloat
    @Published var footerHeight:CGFloat
    @Published var menuDoesAppear:Bool
    @Published var tapOccurred:Bool
    @Published var fieldMaybeInFocus:Field?
    @Published var inEditingMode:Bool
    @Published var authDidFail:Bool
    @Published var mainViewChoice:MarcaViewChoice
    @Published var taskViewChoice:MarcaViewChoice
    @Published var isLogoutChoiceButtonPressed:Bool
    @Published var appFullScreenAspectRatio:CGFloat
    @Published var appFullWidth:CGFloat
    @Published var appFullHeight:CGFloat
    @Published var isLoggingOut:Bool
    @Published var isUserLoggedIn:Bool
    @Published var currentViewTitle:String
    @Published var loggedInUsername:String
    @Published var profile:Profile
    @Published var profileStaffNotes:[[String:String]]
    @Published var user:User?
    @Published var logs:[[String:String]]
    @Published var communityLogs:[[String:String]]
    @Published var cellPhoneDict:[String:String]
    @Published var textGroupEmployees:[IdentifiableGroupEmployees]
    @Published var profileGroupEmployees:[IdentifiableGroupEmployees]
    @Published var overlayIsShowing:Bool
    @Published var profileGroupCats:[IdentifiableGroupCategories]
    @Published var textGroupCats:[IdentifiableGroupCategories]
# ![Marca Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://github.com/jahearnco/MarcaApp/tree/main/MarcaApp/Ancillary/Factories">Factory</a>
    protocol Marca{}
    protocol Singleton{}
    protocol ObservableSingleton:ObservableObject,Singleton{}
    class MarcaClass:Marca{}
    MarcaClassFactory public static func getInstance<T:MarcaClass>(className:String, kType:T.Type, instanceLabel:String=_C.MPTY_STR)->MarcaClass! {} 
    MarcaClassFactory public static func handleNewInstance<T:MarcaClass>(instance:MarcaClass?, kType:T.Type, instanceLabel:String)throws {}
# ![End Banner](Assets.xcassets/smallestlogo.png) &nbsp; <a href="https://www.everphase.net/resume">Everphase</a>
Full Stack :: iOS :: AWS :: iOT :: LAMP :: Smart Devices :: EE :: Engineering Physics

