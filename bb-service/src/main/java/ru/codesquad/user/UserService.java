package ru.codesquad.user;

import ru.codesquad.user.dto.UserDto;
import ru.codesquad.user.dto.UserNewDto;
import ru.codesquad.user.dto.UserShortDto;
import ru.codesquad.user.dto.UserUpdateDto;

import java.util.List;

public interface UserService {

    UserDto addUser(UserNewDto userNewDto);

    UserDto getPrivateUserById(Long userId);

    UserShortDto getPublicUserById(Long userId);

    UserDto updateUser(Long userId, UserUpdateDto userUpdateDto);

    void deletePrivateUser(Long userId);

    void deleteAdminUser(Long userId);

    List<UserDto> getAllUsers(Integer from, Integer size);
}