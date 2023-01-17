//
//  Cognito.swift
//  MarcaApp0105
//
//  Created by Enjoy on 1/7/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPluginsCore
import SwiftUI

struct User{
    var authLoginName:String?
    var authId:String?
    var fullName:String?
    var currentlyLoggedIn:Bool = false
    var userFirstNameLastI:String?
    var userId:String?
    var userRole:String? = "S"
    var userWorkgroups:String? = "2147483647"
    var logviewTimeframe:String? = "\(3600*1000*55)"//2 days
}

final class Cognito:MarcaClass,Singleton {
    /**begin:Requirements to adhere to Singleton Protocol*/
    private static var _inst:Singleton?
    static func getStaticInstance() -> Singleton? { return _inst as? Self }
    static func setStaticInstance(si: Singleton!) { _inst = si as! Self }
    /**end:Requirements to adhere to Singleton Protocol*/
    
    public static func getUser(loggedInUser:AuthUser?)async->User{
        var user:User = User()
        if let au = loggedInUser{
            print("Cognito getUser() authUser : \(au) ")
            user.currentlyLoggedIn = true
            user.authLoginName = au.username
            user.authId = au.userId
            user.userId = getUserId(loggedInUserName:user.authLoginName)
            user.fullName = await getUserFullName(userId:user.userId)
            user.userFirstNameLastI = getUserFirstNameLastI(fullName:user.fullName)
        }else{
            print("Cognito getUser() authUser : no user is logged in ")
            user.currentlyLoggedIn = false
            user.authLoginName = "no auth login name"
            user.authId = "no auth id"
            user.userId = "no user id"
            user.fullName = "no full name"
            user.userFirstNameLastI = "no first l name"
        }
        return user
    }
    
    public static func getAuthUser()async->AuthUser?{
        var authUser:AuthUser?
        do{
            authUser = try await Amplify.Auth.getCurrentUser()
        }catch{
            print(error)
        }
        return authUser
    }
    
    private static func getUserId(loggedInUserName:String?)->String?{
        var retName:String?
        if let loginName = loggedInUserName {
            retName = loginName.replacingOccurrences(of: "@", with: "AT")
        }
        return retName
    }
    
    private static func getUserFullName(userId:String?) async -> String?{
        var humanName:String?
        if let userId = userId{
            do {
                let urlEncodedId = userId.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                print("BEGIN: getUsername w urlEncodedId: \(urlEncodedId!)")
                let request = RESTRequest(path:"/metaSessions/\(urlEncodedId!)")
                print("BEGIN:calling getUsername Amplify.API.get")
                let data = try await Amplify.API.get(request: request)
                print("END:calling getUsername Amplify.API.get")
                if let metaSessionDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                {
                    let maybeName = metaSessionDict["employeeName"] as? String
                    if let name = maybeName {
                        humanName = name
                        print("emp name = \(humanName!)")
                    }else{
                        for (k,_) in metaSessionDict{
                            if let val = metaSessionDict[k]{
                                print("for k:\(k) v = \(val)")
                            }
                        }
                    }
                    
                }else{
                    print("data = ???")
                }
                
            } catch let error as APIError {
                print("Failed due to API error: ", error)
                
                
                if case let .httpStatusError(_, response) = error, let awsResponse = response as? AWSHTTPURLResponse {
                     if let responseBody = awsResponse.body {
                         print("Response contains a \(responseBody.count) byte long response body")
                         print("awsResponse : \(awsResponse) ")
                         print("responseBody : \(responseBody) ")
                     }
                 }
                
            } catch {
                print("Unexpected error: \(error)")
            }
        }
        return humanName
    }
    
    public static func getUserFirstNameLastI(fullName:String?)->String?{
        var firstNameLastI:String?
        if let fn = fullName{
            let lineItems:[String] = fn.components(separatedBy: ",")
            if (lineItems.count > 0){
                let fn:String = lineItems.count > 1 ? (lineItems[1] as String).trim() : (lineItems[0] as String).trim()
                let ln:String = lineItems.count > 1 ? (lineItems[0] as String).trim() : ""
                let lastInitial:String = ln.first?.description ?? ""
                firstNameLastI = fn + " " + lastInitial
            }
        }
        return firstNameLastI
    }
    
    public static func authSignOut()async->Bool{
        let signOutResult:AuthSignOutResult? = await Amplify.Auth.signOut()
        if let sor = signOutResult{
            print("Cognito.authSignOut AuthSignOutResult = \(sor)")
            return true
        }else{
            return false
        }
    }

    public static func doLogin(autoLogin:Bool, u: String, p: String) async -> Bool{
        var authUsername = u
        var password = p
        if (autoLogin){
            authUsername="john@everphase.net"
            password="zipd00d@@"
        }
        return await signIn(authUsername:authUsername, password:password)
    }
    
    private static func signIn(authUsername: String, password: String) async->Bool{
        var signedIn:Bool = false
        do{
            let signInResult:AuthSignInResult? = try await Amplify.Auth.signIn(username:authUsername, password: password)
            if let unwrappedSIR = signInResult {
                if unwrappedSIR.isSignedIn {
                    print("unwrappedSIR = \(unwrappedSIR)")
                    print("Sign in SUCCESS")
                    signedIn = true
                }else{
                    print("Sign in FAIL")
                    signedIn = false
                }
            }
            
        }catch{
            print(error)
            return false
        }
        return signedIn
    }
    
    /*
    private static func fetchCurrentAuthSession() async -> String?{
        var idToken:String?
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            
            // Get cognito user pool token
            if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                idToken = tokens.idToken
                print("tokens.idToken = \(idToken!)")
                // Do something with the JWT tokens
            }

        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        return idToken
    }
     */
    
    /*
    func doALoginProcess(){
        Task{
            let userIsSignedIn = await userIsSignedIn()
            
            if (userIsSignedIn){
                let uName = self.cognitoLoginName ?? "nouser"
                print("user \(uName) is signed in")
                
                print("user \(uName) is signing out now ...")
                
                let signOutResult = await Amplify.Auth.signOut()
                
                print("user \(uName) has signed out with result = \(signOutResult) ")
            }else{
                print("no user is signed in")
                
                print("signing in now ... ")
                
                await signIn(cognitoLoginName: "hazyjz", password: "A#@r0n0v")
            }
        }
    }
    */
    
    /*
     /// Returns the ID of the identity pool with the specified name.
     /// - Parameters:
     ///   - name: The name of the identity pool whose ID should be returned
     /// - Returns: A string containing the ID of the specified identity pool or `nil` on error or if not found
     ///
     // snippet-start:[cognitoidentity.swift.get-pool-id]
     func getIdentityPoolID(name: String) async throws -> String? {
         var token: String? = nil
         
         // Iterate over the identity pools until a match is found.
         repeat {
             /// `token` is a value returned by `ListIdentityPools()` if the returned list
             /// of identity pools is only a partial list. You use the `token` to tell Cognito that
             /// you want to continue where you left off previously; specifying `nil` or not providing
             /// it means "start at the beginning."
             
             let listPoolsInput = ListIdentityPoolsInput(maxResults: 25, nextToken: token)
             
             /// Read pages of identity pools from Cognito until one is found
             /// whose name matches the one specified in the `name` parameter.
             /// Return the matching pool's ID. Each time we ask for the next
             /// page of identity pools, we pass in the token given by the
             /// previous page.
             
             do {
                 let output = try await cognitoIdentityClient.listIdentityPools(input: listPoolsInput)

                 if let identityPools = output.identityPools {
                     for pool in identityPools {
                         if pool.identityPoolName == name {
                             return pool.identityPoolId!
                         }
                     }
                 }
                 
                 token = output.nextToken
             } catch {
                 print("ERROR: ", dump(error, name: "Trying to get list of identity pools"))
             }
         } while token != nil
         
         return nil
     }
    */

    /*
    func updateSignedInStatus() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if session.isSignedIn {
                let user = try await Amplify.Auth.getCurrentUser()
                await MainActor.run {
                    self.cognitoLoginName = user.cognitoLoginName
                }
            }
        } catch {
            print(error)
        }
    }

    func signUp(cognitoLoginName: String, password: String, email: String) async {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = Amplify.Auth.signUp(
                cognitoLoginName: cognitoLoginName,
                password: password,
                options: options
            )
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    */
    
    /*
    func confirmSignUp(for cognitoLoginName: String, with confirmationCode: String) async {
        do {
            let confirmSignUpResult = Amplify.Auth.confirmSignUp(
                for: cognitoLoginName,
                confirmationCode: confirmationCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.)")
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
     */
}
